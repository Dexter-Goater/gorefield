extends  Node2D
var arrow_direction
var directions = ["UP","LEFT","RIGHT","DOWN","RIGHT","LEFT","DOWN","UP","DOWN","RIGHT","DOWN","RIGHT","DOWN","LEFT","RIGHT","LEFT","DOWN","DOWN","LEFT","END"]
func _ready() -> void:
	Globals.gorefield_appeasment = 5
func _process(delta: float) -> void:
	if Globals.minigame == 2 and Globals.current_recipie == "Pizza":
		arrow_direction = directions[0]
		if arrow_direction == "END":
			Globals.minigame += 1
		else:
			$Label.text = "Press = {arrow_direction}".format({"arrow_direction":arrow_direction})
			if arrow_direction == "UP":
				$Arrow.rotation = 270
				if Input.is_action_just_pressed("W"):
					Globals.gorefield_appeasment += 1
				else:
					Globals.gorefield_appeasment -= 2
					
			if arrow_direction == "LEFT":
				$Arrow.rotation = 180
				if Input.is_action_just_pressed("A"):
					Globals.gorefield_appeasment += 1
				else:
					Globals.gorefield_appeasment -= 2
			if arrow_direction == "RIGHT":
				$Arrow.rotation = 0
				if Input.is_action_just_pressed("D"):
					Globals.gorefield_appeasment += 1
				else:
					Globals.gorefield_appeasment -= 2
			if arrow_direction == "DOWN":
				$Arrow.rotation = 90
				if Input.is_action_just_pressed("S"):
					Globals.gorefield_appeasment += 1
				else:
					Globals.gorefield_appeasment -= 2
