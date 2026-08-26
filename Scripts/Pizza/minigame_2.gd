extends Node2D

var arrow_direction
var current_index = 0
var directions = ["D","W","D","S","D","A","S","W","S","D","S","D","S","A","D","A","S","W","A","END"]

func _ready() -> void:
	Globals.gorefield_appeasment = 5
	update_arrow()
	$Sprite2D.play("Pre_Roll")

func _process(_delta: float) -> void:
	if Globals.minigame == 2 and Globals.current_recipie == "Pizza":
		if directions[current_index] == "END":
			Globals.minigame += 1
			set_process(false)

func _unhandled_input(event: InputEvent) -> void:
	if Globals.minigame != 2 or Globals.current_recipie != "Pizza":
		return
		
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var current_target = directions[current_index]
		if current_target == "END":
			return
			
		# Convert the pressed key directly into uppercase string ("W", "A", "S", "D")
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
