extends Node2D
var animdone = false

func _on_button_pressed() -> void:
	if animdone:
		get_tree().change_scene_to_file("res://Scenes/credits.tscn")


func _on_animated_sprite_2d_animation_finished() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	animdone = true
