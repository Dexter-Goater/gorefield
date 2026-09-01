extends Node2D
var arrow_direction
var current_index = 0
var directions = ["D","W","D","S","D","A","S","W","S","D","S","D","S","A","D","A","S","W","A","END"]
var book_shown_for_step = false
var minigame_started = false
var preroll_played = false
var was_book_up = false

func _ready() -> void:
	Globals.gorefield_appeasment = 5
	update_arrow()

func _process(_delta: float) -> void:
	if Globals.minigame == 2 and Globals.current_recipie == "Pizza":
		if not book_shown_for_step:
			Globals.showbook()
			book_shown_for_step = true
			was_book_up = true

		if was_book_up and not Globals.book_up and not preroll_played:
			$Sprite2D.play("Pre_Roll")
			preroll_played = true
		was_book_up = Globals.book_up

		if not minigame_started and Globals.countdownfin:
			minigame_started = true

		if minigame_started and directions[current_index] == "END":
			Globals.minigame += 1
			Globals.countdownfin = false
			set_process(false)

func _unhandled_input(event: InputEvent) -> void:
	if Globals.minigame != 2 or Globals.current_recipie != "Pizza":
		return
	if not minigame_started:
		return

	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var current_target = directions[current_index]
		if current_target == "END":
			return
		var pressed_key = OS.get_keycode_string(event.physical_keycode)
		if pressed_key == current_target:
			Globals.gorefield_appeasment += 1
			advance_sequence()
		else:
			Globals.gorefield_appeasment -= 2
			advance_sequence()

func advance_sequence() -> void:
	play_completion_animation(current_index)
	current_index += 1
	update_arrow()

func update_arrow() -> void:
	arrow_direction = directions[current_index]
	if arrow_direction != "END":
		$Label.text = "Press = {arrow_direction}".format({"arrow_direction": arrow_direction})

		match arrow_direction:
			"W": $Arrow.rotation_degrees = 270
			"A": $Arrow.rotation_degrees = 180
			"D": $Arrow.rotation_degrees = 0
			"S": $Arrow.rotation_degrees = 90

func play_completion_animation(completed_idx: int) -> void:
	match completed_idx:
		0: $Sprite2D.play("Init1")
		1: $Sprite2D.play("Init2")
		2: $Sprite2D.play("Init3")
		_:
			var completed_dir = directions[completed_idx]
			match completed_dir:
				"W": $Sprite2D.play("W")
				"A": $Sprite2D.play("A")
				"S": $Sprite2D.play("S")
				"D": $Sprite2D.play("D")
