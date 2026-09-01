extends Node2D
var inpizza = false
var book_shown_for_step = false
var minigame_started = false
@onready var custom_icon = $AnimatedSprite2D

func _ready() -> void:
	$Area2D/Sauced.self_modulate.a = 0
	custom_icon.play("Default")
	custom_icon.hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	if Globals.current_recipie == "Pizza" and Globals.minigame == 3:
		if not book_shown_for_step:
			Globals.showbook()
			book_shown_for_step = true
		if not minigame_started and Globals.countdownfin:
			minigame_started = true
		if minigame_started:
			if InputEventMouseMotion and Input.is_action_pressed("Left Click") and inpizza and $Area2D/Sauced.self_modulate.a <= 1:
				$Area2D/Sauced.self_modulate.a += 0.001
				custom_icon.play("Sauced")
			else:
				custom_icon.play("Default")
			if $Area2D/Sauced.self_modulate.a >= 1:
				Globals.minigame += 1
				Globals.countdownfin = false
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			$AnimatedSprite2D.global_position = get_global_mouse_position()

func _on_area_2d_mouse_entered() -> void:
	if Globals.current_recipie == "Pizza" and Globals.minigame == 3:
		inpizza = true
		custom_icon.play("Default")
		custom_icon.show()
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_area_2d_mouse_exited() -> void:
	inpizza = false
	custom_icon.hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
