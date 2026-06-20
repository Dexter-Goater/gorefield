extends Node2D
var inpizza = false
func _ready() -> void:
	$Area2D/Sauced.self_modulate.a = 0	

func _process(delta: float) -> void:
	if Globals.current_recipie == "Pizza" and Globals.minigame == 3 and InputEventMouseMotion and Input.is_action_pressed("Left Click") and inpizza and $Area2D/Sauced.self_modulate.a <= 1:
		$Area2D/Sauced.self_modulate.a += 0.001
	
	if $Area2D/Sauced.self_modulate.a >= 1 and Globals.current_recipie == "Pizza" and Globals.minigame == 3:
		Globals.minigame += 1

func _on_area_2d_mouse_entered() -> void:
	inpizza = true


func _on_area_2d_mouse_exited() -> void:
	inpizza = false
