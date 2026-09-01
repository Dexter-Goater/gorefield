extends Node2D
@onready var veg = 1
var minigame_started = false
var minigame_loaded = false
var book_shown_for_step = false
var was_book_up = false

func _ready() -> void:
	$Veg.frame = 0
	$Veg.play("Veg {veg}")
	$Timer.start()
	$Knife.position.x = -41

func _process(delta: float) -> void:
	if Globals.minigame == 1 and Globals.current_recipie == "Lasagne":
		if not book_shown_for_step:
			Globals.showbook()
			book_shown_for_step = true
			was_book_up = true

		if minigame_loaded == false:
			minigame_loaded = true
			$Label.hide()
			$Veg.hide()
			$Chopping.hide()
			$Knife.hide()

		if minigame_loaded and was_book_up and not Globals.book_up:
			$FirstDown.play("Default")
		was_book_up = Globals.book_up

	if Input.is_action_just_pressed("Left Click") and Globals.minigame == 1 and Globals.current_recipie == "Lasagne" and Globals.countdownfin:
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
		Globals.countdownfin = false
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
