extends Node2D
var mouse_in = false
var minigame_started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if minigame_started == true:
		$Pivot.rotation += 0.5 * delta
		if mouse_in == true:
			Globals.gorefield_appeasment += 0.01
		if mouse_in == false:
			Globals.gorefield_appeasment -= 0.1
		print(Globals.gorefield_appeasment)

func _on_area_2d_mouse_entered() -> void:
	if Globals.minigame == 3:
		if minigame_started == false:
			minigame_started = true
		mouse_in = true



func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
