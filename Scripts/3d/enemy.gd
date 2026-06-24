extends CharacterBody3D
var direction = Vector3.ZERO
var moving = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../Timer".start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_pos = $"../FpsController".global_position
	target_pos.y = global_position.y
	look_at(target_pos, Vector3.UP)
	if moving == true:
		direction.x += 1
	
	move_and_slide()


func _on_timer_timeout() -> void:
	moving = true
	print("timer done")
