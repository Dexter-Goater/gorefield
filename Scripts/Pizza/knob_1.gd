extends Node2D
signal knob1
var following := false
var MAX_DIST := 2000


var SENSITIVITY := 0.7


var MAX_TURN_SPEED := 4.0


var MIN_ROTATION := 0.0
var MAX_ROTATION := deg_to_rad(300.0)

var last_mouse_angle := 0.0
var knob_angle := 0.0

func _ready() -> void:
	knob_angle = clamp($Knob.rotation, MIN_ROTATION, MAX_ROTATION)

func _process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	var mouseDist := mouse_pos.distance_squared_to($Knob.global_position)

	if Globals.minigame == 4 and Globals.current_recipie == "Pizza":
		if mouseDist < MAX_DIST and Input.is_action_just_pressed("Left Click"):
			following = true
			last_mouse_angle = mouse_pos.angle_to_point($Knob.global_position)

		if Input.is_action_just_released("Left Click"):
			following = false

		if following:
			var current_mouse_angle := mouse_pos.angle_to_point($Knob.global_position)
			var raw_delta := angle_difference(last_mouse_angle, current_mouse_angle)
			last_mouse_angle = current_mouse_angle

			var wanted_delta := raw_delta * SENSITIVITY
			var max_step := MAX_TURN_SPEED * delta
			wanted_delta = clamp(wanted_delta, -max_step, max_step)

			knob_angle = clamp(knob_angle + wanted_delta, MIN_ROTATION, MAX_ROTATION) 
			$Knob.rotation = knob_angle

			var ang := knob_angle
			if ang >= 4.1 and ang <= 4.2:
				knob1.emit()
