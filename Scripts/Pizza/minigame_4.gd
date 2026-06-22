extends Node2D
var mouse_in = false
var oven_prepped = false
var knob1 = false
var knob2 = false

func _on_knob_1_knob_1() -> void:
	knob1 = true


func _on_knob_2_knob_2() -> void:
	knob2 = true

func _process(delta: float) -> void:
	if Globals.minigame == 4 and Globals.current_recipie == "Pizza":
		if knob1 and knob2:
			oven_prepped = true
		if oven_prepped and mouse_in and Input.is_action_just_pressed("Left Click"):
			for recipie in Globals.old_recipies:
				if Globals.old_recipies.size() != Globals.recipies.size():
					if Globals.current_recipie == recipie:
						Globals.current_recipie = Globals.recipies.pick_random()
					elif Globals.current_recipie != recipie:
						Globals.minigame = 1
				else:
					Globals.minigame_over = true

func _on_area_2d_mouse_entered() -> void:
	if Globals.minigame == 4 and Globals.current_recipie == "Pizza":
		mouse_in = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
