extends Area3D
var playerinelv = false

func _process(delta: float) -> void:
	if Globals.gens_active == 3 and playerinelv:
		get_tree().change_scene_to_file("res://Scenes/2d/Win_screen.tscn")

func _on_body_entered(body: Node3D) -> void:
	if body.name == "FpsController":
		playerinelv = true


func _on_body_exited(body: Node3D) -> void:
	if body.name == "FpsController":
		playerinelv = false
