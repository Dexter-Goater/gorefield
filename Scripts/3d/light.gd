extends SpotLight3D
@onready var timer = $Timer
@export var flicker_range_min := 0.05  
@export var flicker_range_max := 0.2
var mat
func _ready():
	mat = $"..".get_surface_override_material(1) as StandardMaterial3D
	timer.timeout.connect(_on_timer_timeout)
	light_color = Color(0.905,1,0.956)
	mat.emission = Color(0.905,1,0.956)
	Globals.gens_active = 0
	

func _on_timer_timeout():
	if (Globals.chasingplayer == true and Globals.distancetoplayer < Globals.Chase_Indicator_max_distance) or Globals.gens_active == 3:
		light_energy = randf_range(0, 2.0)
		var dist = clamp(Globals.distancetoplayer, Globals.Chase_Indicator_min_distance, Globals.Chase_Indicator_max_distance)
		var t = (dist - Globals.Chase_Indicator_min_distance) / (Globals.Chase_Indicator_max_distance - Globals.Chase_Indicator_min_distance)
		var wait_time = lerp(flicker_range_min, flicker_range_max, t)
		timer.start(wait_time)
	else:
		light_energy = 2
		timer.start(flicker_range_max)

func _process(delta: float) -> void:
	if Globals.gens_active == 3:
		mat = $"..".get_surface_override_material(1) as StandardMaterial3D
		light_color = Color.RED
		mat.emission = Color(1, 0, 0)
	else:
		light_color = Color(0.905, 1, 0.956)
		mat.emission = Color(0.905, 1, 0.956)
