extends Node2D
var mouse_in = false
var minigame_started = false
var animfinished = true
var book_shown_for_step = false
var was_book_up = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Globals.minigame == 3 and Globals.current_recipie == "Lasagne":
		if not book_shown_for_step:
			Globals.showbook()
			book_shown_for_step = true
			was_book_up = true

		if was_book_up and not Globals.book_up and animfinished:
			$AnimatedSprite2D.play("First_Adding")
		was_book_up = Globals.book_up

	if minigame_started == true and Globals.minigame == 3 and Globals.current_recipie == "Lasagne":
		$Pivot.rotation += (TAU / 10) * delta
		if mouse_in == true:
			Globals.gorefield_appeasment += 0.02
		if mouse_in == false:
			Globals.gorefield_appeasment -= 0.07

func _on_area_2d_mouse_entered() -> void:
	if Globals.minigame == 3 and Globals.current_recipie == "Lasagne":
		if minigame_started == false and Globals.countdownfin:
			minigame_started = true
			$"Minigame Over".start()
			$AnimatedSprite2D.play("First Time")
		mouse_in = true

func _on_area_2d_mouse_exited() -> void:
	mouse_in = false

func _on_minigame_over_timeout() -> void:
	Globals.minigame += 1
	Globals.countdownfin = false
	Globals.gorefield_appeasment = 5

func _on_animated_sprite_2d_animation_finished() -> void:
	animfinished = false
	if $AnimatedSprite2D.animation == "First Time":
		$AnimatedSprite2D.play("Looping")
