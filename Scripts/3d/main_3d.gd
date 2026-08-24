extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.threed = true
	Globals.gens_active = 0
	$WorldEnvironment.environment.background_color = Color(1, 1, 1)

func _process(delta: float) -> void:
	if Globals.gens_active == 3:
		$WorldEnvironment.environment.background_color = Color.RED
