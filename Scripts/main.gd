extends Node2D
@onready var veg = 1
func _ready() -> void:
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("Veg {veg}")
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Left Click"):
		$AnimatedSprite2D.frame += 1
		if $AnimatedSprite2D.frame >= 22:
			veg += 1
			$AnimatedSprite2D.play("Veg {veg}".format({'veg':veg}))
