extends Area2D

var is_dragging := false
var drag_start_pos: Vector2
var mouse_in := false

func _input(event: InputEvent) -> void:
	if Globals.current_recipie == "Pizza" or Globals.minigame == 2:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:

				if event.pressed and mouse_in:
					is_dragging = true
					drag_start_pos = event.position

				elif !event.pressed and is_dragging:
					is_dragging = false

					var drag_distance = drag_start_pos.distance_to(event.position)
					var scale_factor = clamp(drag_distance / 100.0, 0.5, 5.0)

					$CollisionShape2D.shape.radius = scale_factor * 0.9
					$CollisionShape2D/Sprite2D.scale = Vector2.ONE * scale_factor / 10

func _on_mouse_entered() -> void:
	mouse_in = true

func _on_mouse_exited() -> void:
	mouse_in = false
