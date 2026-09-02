extends Node3D

enum ColorMode { SEQUENTIAL, RANDOM, RAINBOW }

@export_category("Color Settings")
@export var color_mode: ColorMode = ColorMode.SEQUENTIAL
@export var color_palette: Array[Color] = [
	Color(1, 0, 0),
	Color(0, 1, 0),
	Color(0, 0, 1),
	Color(1, 0, 1),
	Color(1, 1, 0),
	Color(0, 1, 1)
]
@export var color_change_interval: float = 0.3
@export var smooth_transitions: bool = true
@export var transition_speed: float = 8.0

@export_category("Pulse / Strobe Effect")
@export var enable_pulse: bool = true
@export var min_energy: float = 2.0
@export var max_energy: float = 8.0
@export var pulse_speed: float = 6.0

@onready var light: Light3D = $"."

var _timer: float = 0.0
var _current_color_index: int = 0
var _target_color: Color = Color.WHITE
var _current_color: Color = Color.WHITE
var _pulse_time: float = 0.0

func _ready() -> void:
	if color_palette.is_empty():
		color_palette.append(Color.WHITE)
	_target_color = color_palette[0]
	_current_color = _target_color
	light.light_color = _current_color

func _process(delta: float) -> void:
	_handle_color_cycling(delta)
	_handle_pulse(delta)

func _handle_color_cycling(delta: float) -> void:
	_timer += delta
	if color_mode == ColorMode.RAINBOW:
		var hue = fmod(Time.get_ticks_msec() / 1000.0 * 0.5, 1.0)
		_target_color = Color.from_hsv(hue, 1.0, 1.0)
	elif _timer >= color_change_interval:
		_timer = 0.0
		_advance_color()
	if smooth_transitions and color_mode != ColorMode.RAINBOW:
		_current_color = _current_color.lerp(_target_color, delta * transition_speed)
	else:
		_current_color = _target_color
	light.light_color = _current_color

func _advance_color() -> void:
	if color_palette.is_empty():
		return
	match color_mode:
		ColorMode.SEQUENTIAL:
			_current_color_index = (_current_color_index + 1) % color_palette.size()
			_target_color = color_palette[_current_color_index]
		ColorMode.RANDOM:
			var next_index = randi() % color_palette.size()
			if color_palette.size() > 1 and next_index == _current_color_index:
				next_index = (next_index + 1) % color_palette.size()
			_current_color_index = next_index
			_target_color = color_palette[_current_color_index]

func _handle_pulse(delta: float) -> void:
	if not enable_pulse:
		return
	_pulse_time += delta * pulse_speed
	var wave = (sin(_pulse_time) + 1.0) * 0.5
	light.light_energy = lerp(min_energy, max_energy, wave)
