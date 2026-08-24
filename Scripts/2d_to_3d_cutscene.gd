extends Node2D


# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/3d/main_3d.tscn")
