extends CharacterBody3D
var direction = Vector3.ZERO
var moving = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../Timer".start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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


func _on_timer_timeout() -> void:
	moving = true
	print("timer done")
