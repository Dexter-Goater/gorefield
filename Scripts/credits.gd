extends Node2D
func _process(delta: float) -> void:
	position.y += 0.2


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/2d/main_menu.tscn")
