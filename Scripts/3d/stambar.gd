extends CanvasLayer

@export var player : Player
@export var hide_when_full : bool = true
@export var fade_speed : float = 4.0

@onready var bar_root : Node2D = $Barroot
@onready var fill : Sprite2D = $Barroot/StaminaBarFill

var _full_region : Rect2
var _target_alpha : float = 0.0

func _ready() -> void:
	fill.centered = false
	fill.region_enabled = true
	if fill.region_rect == Rect2():
		fill.region_rect = Rect2(Vector2.ZERO, fill.texture.get_size())
	_full_region = fill.region_rect
	bar_root.modulate.a = 0.0
	if not player:
		player = get_tree().get_first_node_in_group("player")
	if player:
		player.stamina_changed.connect(_on_stamina_changed)
		_on_stamina_changed(player.stamina, player.max_stamina)

func _process(delta: float) -> void:
	bar_root.modulate.a = move_toward(bar_root.modulate.a, _target_alpha, fade_speed * delta)

func _on_stamina_changed(current : float, max_value : float) -> void:
	var ratio : float = current / max_value
	var region : Rect2 = _full_region
	region.size.x = _full_region.size.x * ratio
	fill.region_rect = region

	if hide_when_full:
		_target_alpha = 0.0 if current >= max_value else 1.0
	else:
		_target_alpha = 1.0
