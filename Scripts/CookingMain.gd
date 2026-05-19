extends Node2D
@onready var current_minigame = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_minigame != Globals.minigame:
		for child in get_children(): if child.name.begins_with("Minigame"): child.visible = (child.name == "Minigame " + str(current_minigame))
		current_minigame += 1 
		print(Globals.minigame)
		print(current_minigame)
