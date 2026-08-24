extends Node2D

var arrow_direction
var current_index = 0
var directions = ["D","W","D","S","D","A","S","W","S","D","S","D","S","A","D","A","S","S","A","END"]

func _ready() -> void:
	Globals.gorefield_appeasment = 5
	update_arrow()
	update_animation()

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
		var correct_action = ""
		
		match current_target:
			"W": correct_action = "forward"
			"A": correct_action = "left"
			"D": correct_action = "right"
			"S": correct_action = "backward"
			"END": return

		if event.is_action_pressed(correct_action):
			Globals.gorefield_appeasment += 1
			advance_sequence()
		else:
			Globals.gorefield_appeasment -= 2
			advance_sequence()

func advance_sequence() -> void:
	current_index += 1
	update_arrow()
	update_animation()

func update_arrow() -> void:
	arrow_direction = directions[current_index]
	if arrow_direction != "END":
		$Label.text = "Press = {arrow_direction}".format({"arrow_direction": arrow_direction})
		
		match arrow_direction:
			"W": $Arrow.rotation_degrees = 270
			"A": $Arrow.rotation_degrees = 180
			"D": $Arrow.rotation_degrees = 0
			"S": $Arrow.rotation_degrees = 90

func update_animation() -> void:
	match current_index:
		0:
			$Sprite2D.play("Pre_Roll")
		1:
			$Sprite2D.play("Init1")
		2:
			$Sprite2D.play("Init2")
		3:
			$Sprite2D.play("Init3")
		_:
			var current_dir = directions[current_index]
			if current_dir != "END":
				$Sprite2D.play(current_dir)
