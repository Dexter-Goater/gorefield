extends CharacterBody3D
var direction = Vector3.ZERO
enum State {IDLE, WAITING_TO_MOVE, MOVE, CHASE, INVESTIGATE, SEARCHING}
var state : State = State.IDLE
const SPEED = 10
const CHASE_SPEED = 14
const INVESTIGATE_SPEED = 8
var idle_wait_time: float = 0.1
var idle_timer_count: float = 0

var stuck_check_interval: float = 1.5
var stuck_check_timer: float = 0.0
var stuck_distance_threshold: float = 0.5
var last_check_position: Vector3 = Vector3.ZERO

var investigate_stuck_check_interval: float = 0.6
var investigate_stuck_distance_threshold: float = 0.3

var vision_check_interval: float = 0.1
var vision_check_timer: float = 0.0

@export var body_radius: float = 0.6
@export var corner_avoidance_ray_length: float = 1.2
@export var corner_avoidance_angle_deg: float = 35.0
@export var corner_avoidance_strength: float = 1.5

@export_category("Turn Speed (radians/sec)")
@export var turn_speed_wander: float = 6.0
@export var turn_speed_chase: float = 10.0
@export var turn_speed_investigate: float = 2.5

var player: Node3D = null
var player_in_vision_area: bool = false
var can_see_player: bool = false
var last_known_position: Vector3 = Vector3.ZERO
var last_move_direction: Vector3 = Vector3.FORWARD

var search_points: Array = []
var search_point_index: int = 0
var search_look_time: float = 1.8
var search_look_timer: float = 0.0
var search_radius: float = 6.0
var search_point_count: int = 3
var search_facing_base: Vector3 = Vector3.FORWARD
var search_sweep_amplitude: float = deg_to_rad(65)

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var vision_area: Area3D = $VisionArea

var _nav_map: RID
var _space_state: PhysicsDirectSpaceState3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	vision_area.body_entered.connect(_on_vision_area_body_entered)
	vision_area.body_exited.connect(_on_vision_area_body_exited)
	NoiseManager.noise_emitted.connect(_on_noise_heard)
	_nav_map = navigation_agent_3d.get_navigation_map()
	_space_state = get_world_3d().direct_space_state

func _process(delta: float) -> void:
	vision_check_timer += delta
	if vision_check_timer >= vision_check_interval:
		vision_check_timer = 0.0
		_update_vision()

	match  state:
		State.IDLE:
			_on_idle()
		State.WAITING_TO_MOVE:
			_on_waiting_to_move(delta)
		State.MOVE:
			_on_move(delta)
		State.CHASE:
			_on_chase(delta)
		State.INVESTIGATE:
			_on_investigate(delta)
		State.SEARCHING:
			_on_searching(delta)

	rotation.x = 0
	rotation.z = 0
	if !is_on_floor():
		velocity.y -= 7
	move_and_slide()


func _on_vision_area_body_entered(body: Node3D) -> void:
	if body == player:
		player_in_vision_area = true

func _on_vision_area_body_exited(body: Node3D) -> void:
	if body == player:
		player_in_vision_area = false

func _has_line_of_sight() -> bool:
	if not player_in_vision_area or player == null:
		return false
	var from = global_transform.origin + Vector3(0, 1, 0)
	var to = player.global_transform.origin + Vector3(0, 1, 0)
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]
	var result = _space_state.intersect_ray(query)
	if result.is_empty():
		return true
	return result.collider == player

func _update_vision() -> void:
	if player == null:
		return

	if _has_line_of_sight():
		can_see_player = true
		last_known_position = player.global_transform.origin
		if state != State.CHASE:
			state = State.CHASE
	elif can_see_player:
		can_see_player = false
		state = State.IDLE


func _on_noise_heard(noise_position: Vector3, radius: float, loudness: float) -> void:
	if can_see_player:
		return

	var distance = global_transform.origin.distance_to(noise_position)
	if distance > radius:
		return

	if not _has_line_of_hearing(noise_position):
		return

	last_known_position = noise_position
	_start_investigate()

func _has_line_of_hearing(noise_position: Vector3) -> bool:
	var from = global_transform.origin + Vector3(0, 1, 0)
	var to = noise_position + Vector3(0, 1, 0)
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]
	var result = _space_state.intersect_ray(query)
	return result.is_empty()

func _start_investigate() -> void:
	var safe_target = NavigationServer3D.map_get_closest_point(_nav_map, last_known_position)
	navigation_agent_3d.target_position = safe_target

	if not navigation_agent_3d.is_target_reachable():
		state = State.IDLE
		return

	state = State.INVESTIGATE
	stuck_check_timer = 0.0
	last_check_position = global_transform.origin

func _generate_search_points() -> void:
	search_points.clear()
	search_point_index = 0

	var search_direction = last_move_direction

	var angles = [0.0, deg_to_rad(70), deg_to_rad(-70)]
	for i in range(min(search_point_count, angles.size())):
		var dir = search_direction.rotated(Vector3.UP, angles[i])
		var raw_point = last_known_position + dir * search_radius
		var safe_point = NavigationServer3D.map_get_closest_point(_nav_map, raw_point)
		search_points.append(safe_point)


func _on_idle():
	velocity = Vector3.ZERO
	idle_timer_count = idle_wait_time
	state = State.WAITING_TO_MOVE

func _on_waiting_to_move(delta: float):
	idle_timer_count -= delta
	if idle_timer_count <= 0.0:
		_set_new_target()
		state = State.MOVE

func _set_new_target():
	var target = get_new_target_location()
	var safe_target = NavigationServer3D.map_get_closest_point(_nav_map, target)
	navigation_agent_3d.target_position = safe_target

	if not navigation_agent_3d.is_target_reachable():
		_set_new_target()
		return

	stuck_check_timer = 0.0
	last_check_position = global_transform.origin

func get_new_target_location():
	var offset_x = randf_range(100,1000) * (-1 if randf() < 0.5 else 1)
	var offset_z = randf_range(100,1000) * (-1 if randf() < 0.5 else 1)
	return global_transform.origin + Vector3(offset_x, 0, offset_z)

func _get_corner_avoidance(move_dir: Vector3) -> Vector3:
	var origin = global_transform.origin + Vector3(0, 0.5, 0)
	var angle = deg_to_rad(corner_avoidance_angle_deg)
	var left_dir = move_dir.rotated(Vector3.UP, angle)
	var right_dir = move_dir.rotated(Vector3.UP, -angle)

	var steer = Vector3.ZERO

	var left_query = PhysicsRayQueryParameters3D.create(origin, origin + left_dir * corner_avoidance_ray_length)
	left_query.exclude = [self]
	var left_hit = _space_state.intersect_ray(left_query)
	if not left_hit.is_empty():
		var hit_distance = origin.distance_to(left_hit.position)
		var closeness = 1.0 - clampf(hit_distance / corner_avoidance_ray_length, 0.0, 1.0)
		steer += right_dir.normalized() * closeness

	var right_query = PhysicsRayQueryParameters3D.create(origin, origin + right_dir * corner_avoidance_ray_length)
	right_query.exclude = [self]
	var right_hit = _space_state.intersect_ray(right_query)
	if not right_hit.is_empty():
		var hit_distance = origin.distance_to(right_hit.position)
		var closeness = 1.0 - clampf(hit_distance / corner_avoidance_ray_length, 0.0, 1.0)
		steer += left_dir.normalized() * closeness

	return steer * corner_avoidance_strength

func _move_towards_nav_target(delta: float, speed: float, check_stuck: bool, check_interval: float, check_threshold: float, turn_speed: float) -> bool:
	if check_stuck:
		stuck_check_timer += delta
		if stuck_check_timer >= check_interval:
			var distance_moved = global_transform.origin.distance_to(last_check_position)
			if distance_moved < check_threshold:
				return true
			stuck_check_timer = 0.0
			last_check_position = global_transform.origin

	var current_position = global_transform.origin
	var next_position = navigation_agent_3d.get_next_path_position()
	var move_dir = (next_position - current_position)
	move_dir.y = 0
	if move_dir.length() > 0.01:
		move_dir = move_dir.normalized()
		var avoidance = _get_corner_avoidance(move_dir)
		move_dir = (move_dir + avoidance).normalized()
		last_move_direction = move_dir
		velocity = move_dir * speed
		_turn_towards(move_dir, turn_speed, delta)
	else:
		velocity.x = 0
		velocity.z = 0
	return false

func _turn_towards(move_dir: Vector3, turn_speed: float, delta: float) -> void:
	var target_transform = global_transform.looking_at(global_transform.origin - move_dir, Vector3.UP)
	var max_angle = turn_speed * delta
	var current_quat = global_transform.basis.get_rotation_quaternion()
	var target_quat = target_transform.basis.get_rotation_quaternion()
	var angle_to = current_quat.angle_to(target_quat)
	var weight = 1.0 if angle_to <= max_angle or angle_to == 0.0 else max_angle / angle_to
	global_transform.basis = Basis(current_quat.slerp(target_quat, weight))

func _on_move(delta: float):
	var stuck = _move_towards_nav_target(delta, SPEED, true, stuck_check_interval, stuck_distance_threshold, turn_speed_wander)
	if stuck:
		_set_new_target()

func _on_investigate(delta: float):
	var stuck = _move_towards_nav_target(delta, INVESTIGATE_SPEED, true, investigate_stuck_check_interval, investigate_stuck_distance_threshold, turn_speed_investigate)
	if stuck:
		_generate_search_points()
		state = State.SEARCHING
		search_facing_base = last_move_direction
		search_look_timer = 0.0
		if search_points.size() > 0:
			navigation_agent_3d.target_position = search_points[0]

func _on_searching(delta: float):
	if search_point_index >= search_points.size():
		state = State.IDLE
		return

	if navigation_agent_3d.is_navigation_finished():
		velocity = Vector3.ZERO
		search_look_timer += delta

		var sweep = sin((search_look_timer / search_look_time) * TAU) * search_sweep_amplitude
		var sweep_dir = search_facing_base.rotated(Vector3.UP, sweep)
		look_at(global_transform.origin - sweep_dir, Vector3.UP)

		if search_look_timer >= search_look_time:
			search_look_timer = 0.0
			search_point_index += 1
			if search_point_index < search_points.size():
				navigation_agent_3d.target_position = search_points[search_point_index]
	else:
		_move_towards_nav_target(delta, INVESTIGATE_SPEED, false, 0.0, 0.0, turn_speed_investigate)
		search_facing_base = last_move_direction

func _on_chase(delta: float):
	navigation_agent_3d.target_position = last_known_position
	_move_towards_nav_target(delta, CHASE_SPEED, false, 0.0, 0.0, turn_speed_chase)

func _on_navigation_agent_3d_target_reached() -> void:
	match state:
		State.MOVE:
			state = State.IDLE
		State.INVESTIGATE:
			_generate_search_points()
			state = State.SEARCHING
			search_facing_base = last_move_direction
			search_look_timer = 0.0
			if search_points.size() > 0:
				navigation_agent_3d.target_position = search_points[0]
		State.SEARCHING:
			pass
