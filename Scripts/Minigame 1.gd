extends Node2D
@onready var veg = 1
func _ready() -> void:
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("Veg {veg}")
	$Timer.start()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Left Click") and Globals.minigame == 1:
		$AnimatedSprite2D.frame += 1
		if $AnimatedSprite2D.frame >= 22:
			veg += 1
			Globals.gorefield_appeasment = $Timer.time_left
			print(Globals.gorefield_appeasment)
			$AnimatedSprite2D.play("Veg {veg}".format({'veg':veg}))
			$Timer.start()
	if veg >= 4 and Globals.minigame < 2:
		if Globals.gorefield_appeasment <= 0.0:
			get_tree().change_scene_to_file("res://Scenes/2d_to_3d_cutscene.tscn")
		Globals.gorefield_appeasment = 5
		Globals.minigame += 1
