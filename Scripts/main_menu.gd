extends Node2D
var inplay = false
var inquit = false
var playclicked = false
func _process(_delta: float) -> void:
	if playclicked:
		return
	if inplay:
		if $AnimatedSprite2D.animation != "Hovering_Play":
			$AnimatedSprite2D.play("Hovering_Play")
		if Input.is_action_just_pressed("Left Click"):
			playclicked = true
			$AnimatedSprite2D.play("Play_pressed")
			await $AnimatedSprite2D.animation_finished
			get_tree().change_scene_to_file("res://Scenes/2d/Main.tscn")	
	if inquit:
		if $AnimatedSprite2D.animation != "Hovering_Quit":
			$AnimatedSprite2D.play("Hovering_Quit")
			
		if Input.is_action_just_pressed("Left Click"):
			get_tree().quit()
func _on_play_mouse_entered() -> void:
	inplay = true
func _on_play_mouse_exited() -> void:
	inplay = false
func _on_quit_mouse_entered() -> void:
	inquit = true
func _on_quit_mouse_exited() -> void:
	inquit = false
