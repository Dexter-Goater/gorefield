extends Node2D
func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Left Click"):
		$AnimatedSprite2D.frame += 1
