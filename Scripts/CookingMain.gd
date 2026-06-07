extends Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.gorefield_appeasment = 5
	Globals.current_recipie = Globals.recipies.pick_random()
	print(Globals.current_recipie)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.gorefield_appeasment <= 0.0:
		get_tree().change_scene_to_file("res://Scenes/2d_to_3d_cutscene.tscn")
