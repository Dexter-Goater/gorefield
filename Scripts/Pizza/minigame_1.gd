extends Node2D
var mouse_in = false
var minigame_started = false
var book_shown_for_step = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Globals.minigame == 1 and Globals.current_recipie == "Pizza":
		if not book_shown_for_step:
			Globals.showbook()
			book_shown_for_step = true
	if minigame_started == true and Globals.minigame == 1 and Globals.current_recipie == "Pizza":
		$Pivot.rotation += (TAU / 10) * delta
		if mouse_in == true:
			Globals.gorefield_appeasment += 0.02
		if mouse_in == false:
			Globals.gorefield_appeasment -= 0.07

func _on_area_2d_mouse_entered() -> void:
	if Globals.minigame == 1 and Globals.current_recipie == "Pizza":
		if minigame_started == false and Globals.countdownfin:
			minigame_started = true
			$"Minigame Over".start()
		mouse_in = true

func _on_area_2d_mouse_exited() -> void:
	mouse_in = false

func _on_minigame_over_timeout() -> void:
	Globals.minigame += 1
	Globals.countdownfin = false
	Globals.gorefield_appeasment = 5
