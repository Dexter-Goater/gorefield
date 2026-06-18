extends Node2D

var arrow_direction
var current_index = 0
var directions = ["UP","LEFT","RIGHT","DOWN","RIGHT","LEFT","DOWN","UP","DOWN","RIGHT","DOWN","RIGHT","DOWN","LEFT","RIGHT","LEFT","DOWN","DOWN","LEFT","END"]

func _ready() -> void:
	Globals.gorefield_appeasment = 5
	update_arrow()

func _process(delta: float) -> void:
	if Globals.minigame == 2 and Globals.current_recipie == "Pizza":
		if directions[current_index] == "END":
			print($Sprite2D.scale)
			Globals.minigame += 1
			set_process(false)

func _unhandled_input(event: InputEvent) -> void:
	if Globals.minigame != 2 or Globals.current_recipie != "Pizza":
		return
		
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var current_target = directions[current_index]
		var correct_action = ""
		
		match current_target:
			"UP": correct_action = "W"
			"LEFT": correct_action = "A"
			"RIGHT": correct_action = "D"
			"DOWN": correct_action = "S"
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
	$Sprite2D.scale *= 1.01

func update_arrow() -> void:
	arrow_direction = directions[current_index]
	if arrow_direction != "END":
		$Label.text = "Press = {arrow_direction}".format({"arrow_direction": arrow_direction})
		
		match arrow_direction:
			"UP": $Arrow.rotation_degrees = 270
			"LEFT": $Arrow.rotation_degrees = 180
			"RIGHT": $Arrow.rotation_degrees = 0
			"DOWN": $Arrow.rotation_degrees = 90
