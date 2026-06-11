extends Area2D
var is_dragging: bool = false
var drag_start_pos: Vector2
var mouse_in = false

func _input(event: InputEvent) -> void:
	if Globals.current_recipie == "Pizza" and Globals.minigame == 2:
		
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and mouse_in:
			is_dragging = true
			drag_start_pos = event.position
			print("Started dragging Pizza!")
			
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if is_dragging:
				is_dragging = false
				var drag_distance = drag_start_pos.distance_to(event.position)
				var new_radius = drag_distance / 100
				$CollisionShape2D.shape.radius = new_radius
				$CollisionShape2D/Sprite2D.scale = Vector2(new_radius,new_radius)
				print("Total drag distance in pixels: ", drag_distance)


func _on_mouse_entered() -> void:
	mouse_in = true

func _on_mouse_exited() -> void:
	mouse_in = false
