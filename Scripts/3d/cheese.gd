extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.name == "FpsController":
		Globals.chasingplayer = false
		Globals.gens_active = 0
		get_tree().change_scene_to_file("res://Scenes/3d/main_3d.tscn")
