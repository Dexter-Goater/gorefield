extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.threed = true
	Globals.gens_active = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.gens_active == 3:
		get_tree().change_scene_to_file("res://Scenes/2d/Win_screen.tscn")
