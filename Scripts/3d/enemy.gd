extends CharacterBody3D
var direction = Vector3.ZERO
var moving = false
enum State {IDLE, WAITING_TO_MOVE, MOVE}
var state : State = State.IDLE

var idle_wait_time: float = 1.5
var idle_timer_count: float = 0

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D


func _ready() -> void:
	$"../Timer".start()


func _process(delta: float) -> void:
	match  state:
		State.IDLE:
			_on_idle()
		State.WAITING_TO_MOVE:
			_on_waiting_to_move()
		State.MOVE:
			_on_move()
	
	look_at($"../FpsController".global_position)
	rotation.x = 0
	rotation.z = 0
	if !is_on_floor():
		velocity.y -= 7
	if moving == true:
		var dir = (($"../FpsController".global_position) - (global_position)).normalized()
		dir.y = 0
		velocity = dir * 1
	move_and_slide()

func _on_idle():
	velocity = Vector3.ZERO
	idle_timer_count = idle_wait_time
	state = State.WAITING_TO_MOVE

func _on_waiting_to_move(delta: float):
	idle_timer_count -= delta
	
	if idle_timer_count <= 0.0:
		print(:"time to move!")

func _on_move():
	print("move")



func _on_timer_timeout() -> void:
	moving = true
	print("timer done")
