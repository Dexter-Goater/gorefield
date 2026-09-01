extends Node2D
var mouse_in = false
var oven_prepped = false
var knob1 = false
var knob2 = false
var book_shown_for_step = false
var minigame_started = false
var camera_moved = false
var was_countdownfin = false
var step_completed = false
@onready var camera: Camera2D = $"../../Camera2D"

func _on_knob_1_knob_1() -> void:
	knob1 = true

func _on_knob_2_knob_2() -> void:
	knob2 = true

func _process(delta: float) -> void:
	if Globals.minigame == 4 and Globals.current_recipie == "Pizza":
		if not book_shown_for_step:
			Globals.showbook()
			book_shown_for_step = true
		if not was_countdownfin and Globals.countdownfin and not camera_moved:
			var background := get_tree().current_scene.find_child("Background", true, false)
			var tween := create_tween()
			tween.tween_property(camera, "position:y", 97, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			if background:
				background.play("oven")
			camera_moved = true
		was_countdownfin = Globals.countdownfin
		if not minigame_started and Globals.countdownfin:
			minigame_started = true
		if minigame_started and not step_completed:
			if knob1 and knob2:
				oven_prepped = true
			if oven_prepped and mouse_in and Input.is_action_just_pressed("Left Click"):
				if not Globals.old_recipies.has(Globals.current_recipie):
					Globals.old_recipies.append(Globals.current_recipie)
				var remaining: Array = []
				for r in Globals.recipies:
					if not Globals.old_recipies.has(r):
						remaining.append(r)
				if remaining.size() > 0:
					Globals.current_recipie = remaining.pick_random()
					Globals.minigame = 1
				else:
					Globals.minigame_over = true
					Globals.countdownfin = false
				step_completed = true
				var background := get_tree().current_scene.find_child("Background", true, false)
				var tween_back := create_tween()
				tween_back.tween_property(camera, "position:y", 0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
				if background:
					background.play("Default")

func _on_area_2d_mouse_entered() -> void:
	if Globals.minigame == 4 and Globals.current_recipie == "Pizza":
		mouse_in = true

func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
