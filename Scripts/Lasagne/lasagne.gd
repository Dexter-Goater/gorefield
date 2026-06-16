extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Globals.current_recipie == "Lasagne":
		for child in get_children():
			if child.name.begins_with("Minigame"):
				child.hide()
@onready var current_minigame = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if "Lasagne" not in Globals.old_recipies and Globals.current_recipie == "Lasagne":
		Globals.old_recipies.append(Globals.current_recipie)
		for child in get_children():
			if child.name.begins_with("Minigame"):
				child.hide()
	
	if Globals.current_recipie == "Lasagne":
		if current_minigame != Globals.minigame:
			for child in get_children():
				if child.name.begins_with("Minigame") and child.name.ends_with(str(current_minigame)):
					child.hide()
			current_minigame += 1 
		if current_minigame == Globals.minigame:
			for child in get_children():
				if child.name.begins_with("Minigame") and child.name.ends_with(str(current_minigame)):
					child.show()
	if not Globals.current_recipie == "Lasagne":
		for child in get_children():
			if child.name.begins_with("Minigame"):
				child.hide()
