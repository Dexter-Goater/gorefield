extends Node2D
@onready var current_minigame = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.gorefield_appeasment = 5
	for child in get_children():
		if child.name.begins_with("Minigame"):
			child.hide()
	
	if Globals.gorefield_appeasment == 0:
		get_tree().change_scene_to_file("res://Scenes/2d_to_3d_cutscene.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_minigame != Globals.minigame:
		for child in get_children():
			if child.name.begins_with("Minigame") and child.name.ends_with(str(current_minigame)):
				child.hide()
		current_minigame += 1 
	if current_minigame == Globals.minigame:
		for child in get_children():
			if child.name.begins_with("Minigame") and child.name.ends_with(str(current_minigame)):
				child.show()
