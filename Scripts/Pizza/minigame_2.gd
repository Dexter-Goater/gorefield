extends Area2D
var is_dragging := false
var drag_last_pos: Vector2
var mouse_in := false
var current_scale := 3.0

func _ready() -> void:
	$CollisionShape2D.shape.radius = current_scale * 0.9
	$CollisionShape2D/Sprite2D.scale = Vector2.ONE * current_scale / 10

func _input(event: InputEvent) -> void:
	if Globals.current_recipie == "Pizza" or Globals.minigame == 2:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and mouse_in:
				is_dragging = true
				drag_last_pos = event.position
			elif !event.pressed:
				is_dragging = false

		if event is InputEventMouseMotion and is_dragging:
			var delta = event.position.distance_to(drag_last_pos)
			drag_last_pos = event.position
			current_scale = clamp(current_scale + delta / 100.0, 3.0, 5.0)
			$CollisionShape2D.shape.radius = current_scale * 0.9
			$CollisionShape2D/Sprite2D.scale = Vector2.ONE * current_scale / 10
			print("scaling: ", current_scale)

func _on_mouse_entered() -> void:
	mouse_in = true
	print("mouse entered")

func _on_mouse_exited() -> void:
	mouse_in = false
	print("mouse exited — is_dragging: ", is_dragging)
