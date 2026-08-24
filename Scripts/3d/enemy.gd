extends CharacterBody3D

enum State { PATROL_GENERATOR, WAIT_AT_GENERATOR, CHASE }
var state: State = State.PATROL_GENERATOR

@export_category("Speeds")
@export var speed_patrol: float = 7.0
@export var speed_chase: float = 13.0
@export var turn_speed: float = 10.0

@export_category("Generator Patrol")
@export var generator_group: StringName = &"generators"
@export var wait_at_generator_time: float = 2.0

@export_category("Stuck Settings")
@export var max_stuck_seconds: int = 3
@export var min_distance_per_second: float = 2.0 

@export_category("Model Settings")
@export var flip_model_facing: bool = true

var player: Node3D = null
var current_generator: Node3D = null
var player_in_vision_area: bool = false
var wait_timer: float = 0.0

var vision_check_interval: float = 0.05
var vision_check_timer: float = 0.0

var stuck_interval_timer: float = 0.0
var stuck_seconds_count: int = 0
var last_check_position: Vector3 = Vector3.ZERO

var path_update_timer: float = 0.0
var path_update_interval: float = 0.1 

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var vision_area: Area3D = $VisionArea

var _space_state: PhysicsDirectSpaceState3D

@onready var chase_audio_player = $ChaseAudioPlayer 
@export var chase_sounds: Array[AudioStream] = [
	preload("res://Audio/3D/ChaseMusic/Chase1.mp3"),
	preload("res://Audio/3D/ChaseMusic/Chase2.mp3"),
	preload("res://Audio/3D/ChaseMusic/Chase3.mp3"),
	preload("res://Audio/3D/ChaseMusic/Chase4.mp3"),
	preload("res://Audio/3D/ChaseMusic/Chase5.mp3"),
	preload("res://Audio/3D/ChaseMusic/Chase6.mp3"),
]
@onready var voice_line_player: AudioStreamPlayer3D = $VoiceLinePlayer 
const FOLDER_PATH: String = "res://Audio/3D/Gorfield/"
var voice_lines: Array[AudioStream] = []
var voice_line_timer: float = 0.0
var next_line_interval: float = 0.0

@export var min_db := -40.0 
@export var max_db := 0.0      
var is_playing_chase_audio := false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	vision_area.body_entered.connect(_on_vision_area_body_entered)
	vision_area.body_exited.connect(_on_vision_area_body_exited)
	_space_state = get_world_3d().direct_space_state
	last_check_position = global_position
	await get_tree().physics_frame
	_pick_random_generator()
	chase_audio_player.finished.connect(_on_chase_audio_finished)
	

	_load_gorfield_voice_lines()
	_reset_voice_line_timer()

func _process(delta: float) -> void:
	if Globals.gens_active == 3:
		state = State.CHASE
	Globals.distancetoplayer = navigation_agent_3d.distance_to_target()
	

	_handle_voice_line_timer(delta)
	
	vision_check_timer += delta
	if vision_check_timer >= vision_check_interval:
		vision_check_timer = 0.0
		_check_vision()
		
	_check_stuck(delta)
	
	match state:
		State.PATROL_GENERATOR:
			_on_patrol_generator(delta)
		State.WAIT_AT_GENERATOR:
			_on_wait_at_generator(delta)
		State.CHASE:
			_on_chase(delta)
			
	rotation.x = 0.0
	rotation.z = 0.0
	if not is_on_floor():
		velocity.y -= 20.0 * delta
	move_and_slide()
	
	if Globals.chasingplayer and Globals.distancetoplayer < Globals.Chase_Indicator_max_distance:
		if not is_playing_chase_audio:
			_start_chase_audio()

		var t = clamp(Globals.distancetoplayer / Globals.Chase_Indicator_max_distance, 0.0, 1.0)
		chase_audio_player.volume_db = lerp(max_db, min_db, t)
	else:
		if is_playing_chase_audio:
			_stop_chase_audio()


func _load_gorfield_voice_lines() -> void:
	var files: PackedStringArray = DirAccess.get_files_at(FOLDER_PATH)
	for file in files:
		if file.ends_with(".import"):
			continue
		
		if file.ends_with(".mp3") or file.ends_with(".wav") or file.ends_with(".ogg"):
			var file_path = FOLDER_PATH.path_join(file)
			var stream = load(file_path) as AudioStream
			if stream:
				voice_lines.append(stream)
				
	if voice_lines.is_empty():
		push_warning("No valid audio files found in directory: " + FOLDER_PATH)

func _handle_voice_line_timer(delta: float) -> void:
	if voice_lines.is_empty():
		return
		
	voice_line_timer += delta
	if voice_line_timer >= next_line_interval:
		_play_random_voice_line()
		_reset_voice_line_timer()

func _reset_voice_line_timer() -> void:
	voice_line_timer = 0.0
	next_line_interval = randf_range(10.0, 20.0)

func _play_random_voice_line() -> void:
	if voice_lines.size() > 0 and voice_line_player:
		voice_line_player.stream = voice_lines.pick_random()
		voice_line_player.play()
		print("sound played")

func _check_stuck(delta: float) -> void:
	if state == State.WAIT_AT_GENERATOR:
		_reset_stuck_tracker()
		return
	stuck_interval_timer += delta
	if stuck_interval_timer >= 1.0:
		stuck_interval_timer = 0.0
		var dist_moved = global_position.distance_to(last_check_position)
		last_check_position = global_position
		if dist_moved < min_distance_per_second:
			stuck_seconds_count += 1
			if stuck_seconds_count >= max_stuck_seconds:
				_reset_stuck_tracker()
				_pick_nearest_generator()
		else:
			stuck_seconds_count = 0

func _reset_stuck_tracker() -> void:
	stuck_interval_timer = 0.0
	stuck_seconds_count = 0
	last_check_position = global_position

func _pick_random_generator() -> void:
	var generators = get_tree().get_nodes_in_group(generator_group)
	if generators.is_empty():
		push_error("Enemy AI Error: No nodes found in group '%s'!" % generator_group)
		return
	var valid_generators = generators.duplicate()
	if current_generator in valid_generators and valid_generators.size() > 1:
		valid_generators.erase(current_generator)
	current_generator = valid_generators.pick_random()
	navigation_agent_3d.target_position = current_generator.global_position
	state = State.PATROL_GENERATOR
	_reset_stuck_tracker()

func _pick_nearest_generator() -> void:
	var generators = get_tree().get_nodes_in_group(generator_group)
	if generators.is_empty():
		push_error("Enemy AI Error: No nodes found in group '%s'!" % generator_group)
		return
	var nearest: Node3D = null
	var nearest_dist: float = INF
	for gen in generators:
		var dist = global_position.distance_squared_to(gen.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = gen
	if nearest != null:
		current_generator = nearest
		navigation_agent_3d.target_position = current_generator.global_position
		state = State.PATROL_GENERATOR
		_reset_stuck_tracker()

func _on_patrol_generator(delta: float) -> void:
	_move_towards_target(delta, speed_patrol)
	if navigation_agent_3d.is_navigation_finished():
		state = State.WAIT_AT_GENERATOR
		wait_timer = wait_at_generator_time
		velocity.x = 0.0
		velocity.z = 0.0

func _on_wait_at_generator(delta: float) -> void:
	velocity.x = 0.0
	velocity.z = 0.0
	wait_timer -= delta
	if wait_timer <= 0.0:
		_pick_random_generator()

func _on_chase(delta: float) -> void:
	if player == null or _is_player_in_locker():
		_pick_nearest_generator()
		Globals.chasingplayer = false
		return
	Globals.chasingplayer = true
	Globals.distancetoplayer = navigation_agent_3d.distance_to_target()
	path_update_timer += delta
	if path_update_timer >= path_update_interval:
		path_update_timer = 0.0
		navigation_agent_3d.target_position = player.global_position
	_move_towards_target(delta, speed_chase)

func _on_vision_area_body_entered(body: Node3D) -> void:
	if body == player:
		player_in_vision_area = true

func _on_vision_area_body_exited(body: Node3D) -> void:
	if body == player:
		player_in_vision_area = false

func _check_vision() -> void:
	if state == State.CHASE or player == null:
		return
	if player_in_vision_area and not _is_player_in_locker() and _has_line_of_sight():
		state = State.CHASE
		_reset_stuck_tracker()

func _has_line_of_sight() -> bool:
	if player == null:
		return false
	var from = global_position + Vector3(0, 1.0, 0)
	var to = player.global_position + Vector3(0, 1.0, 0)
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]
	var result = _space_state.intersect_ray(query)
	if result.is_empty():
		return true
	return result.collider == player

func _is_player_in_locker() -> bool:
	if player == null:
		return false
	if "is_in_locker" in player and player.is_in_locker:
		return true
	if "is_hidden" in player and player.is_hidden:
		return true
	if player.has_method("is_in_locker") and player.is_in_locker():
		return true
	return false

func _move_towards_target(delta: float, move_speed: float) -> void:
	var next_position = navigation_agent_3d.get_next_path_position()
	var move_dir = (next_position - global_position)
	move_dir.y = 0.0
	if move_dir.length() > 0.01:
		move_dir = move_dir.normalized()
		velocity.x = move_dir.x * move_speed
		velocity.z = move_dir.z * move_speed
		_turn_towards(move_dir, delta)
	else:
		velocity.x = 0.0
		velocity.z = 0.0

func _turn_towards(move_dir: Vector3, delta: float) -> void:
	var look_dir = -move_dir if flip_model_facing else move_dir
	var target_transform = global_transform.looking_at(global_position + look_dir, Vector3.UP)
	var max_angle = turn_speed * delta
	var current_quat = global_transform.basis.get_rotation_quaternion()
	var target_quat = target_transform.basis.get_rotation_quaternion()
	var angle_to = current_quat.angle_to(target_quat)
	if angle_to > 0.001:
		var weight = clampf(max_angle / angle_to, 0.0, 1.0)
		global_transform.basis = Basis(current_quat.slerp(target_quat, weight))

func _start_chase_audio():
	chase_audio_player.stream = chase_sounds[randi() % chase_sounds.size()]
	chase_audio_player.play()
	is_playing_chase_audio = true

func _stop_chase_audio():
	chase_audio_player.stop()
	is_playing_chase_audio = false

func _on_chase_audio_finished():
	if is_playing_chase_audio:
		_start_chase_audio()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "FpsController":
		Globals.chasingplayer = false
		Globals.gens_active = 0
		get_tree().change_scene_to_file("res://Scenes/3d/main_3d.tscn")
