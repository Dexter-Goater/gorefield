extends Node2D
@onready var veg = 1
var minigame_started = false
var minigame_loaded = false
func _ready() -> void:
	$Veg.frame = 0
	$Veg.play("Veg {veg}")
	$Timer.start()
	$Knife.position.x = -41
func _process(delta: float) -> void:
	if Globals.minigame == 1 and Globals.current_recipie == "Lasagne":
		if minigame_loaded == false:
			minigame_loaded = true
			$Label.hide()
			$Veg.hide()
			$Chopping.hide()
			$Knife.hide()
		if minigame_loaded:
			$FirstDown.play("Default")
	if Input.is_action_just_pressed("Left Click") and Globals.minigame == 1 and Globals.current_recipie == "Lasagne":
		if minigame_started == false:
			minigame_started = true
			$Timer.start()
			$FirstDown.hide()
			$Label.show()
			$Veg.show()
			$Chopping.show()
			$Knife.show()
		$Veg.frame += 1
		$Knife.position.x += 2.1
		$Knife.play("Chop")
		if $Veg.frame >= $Veg.sprite_frames.get_frame_count($Veg.animation) - 1:
			veg += 1
			Globals.gorefield_appeasment = $Timer.time_left
			print(Globals.gorefield_appeasment)
			$Veg.animation = "Veg {veg}".format({'veg':veg})
			$Veg.frame = 0
			$Veg.stop() 
			$Timer.start()
			$Knife.position.x = -41
	if veg >= 4 and Globals.minigame < 2 and Globals.current_recipie == "Lasagne":
		if Globals.gorefield_appeasment <= 0.0:
			get_tree().change_scene_to_file("res://Scenes/2d_to_3d_cutscene.tscn")
		Globals.gorefield_appeasment = 5
		Globals.minigame += 1
	if not Globals.current_recipie == "Lasagne":
		for child in get_children():
			if child.name.begins_with("Minigame"):
				child.hide()


func _on_first_down_animation_finished() -> void:
	$FirstDown.hide()
	$Label.show()
	$Veg.show()
	$Chopping.show()
	$Knife.show()
	
