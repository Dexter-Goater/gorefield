extends SpotLight3D
@onready var timer = $Timer
@export var flicker_range_min := 0.05  
@export var flicker_range_max := 0.2

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if Globals.chasingplayer == true and Globals.distancetoplayer < Globals.Chase_Indicator_max_distance:
		light_energy = randf_range(0, 2.0)
		var dist = clamp(Globals.distancetoplayer, Globals.Chase_Indicator_min_distance, Globals.Chase_Indicator_max_distance)
		var t = (dist - Globals.Chase_Indicator_min_distance) / (Globals.Chase_Indicator_max_distance - Globals.Chase_Indicator_min_distance)
		var wait_time = lerp(flicker_range_min, flicker_range_max, t)
		timer.start(wait_time)
	else:
		light_energy = 2
		timer.start(flicker_range_max)
