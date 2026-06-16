extends Node2D
var order = ["Ragu","Pasta","Ragu","Bechamel","Pasta","Ragu","Bechamel","Pasta","Ragu","Bechamel","Pasta","Ragu","Bechamel","Pasta","Ragu","end"]
var intray = false
var inragu = false
var insauce = false
var inpasta = false

var raguud = false
var sauced = false
var pastaed = false
var ingredient


func _process(delta: float) -> void:
	if Globals.minigame == 4 and Globals.current_recipie == "Lasagne":
		ingredient = order[0]
		if ingredient == "end":
			for recipie in Globals.old_recipies:
				print(Globals.old_recipies)
				if Globals.old_recipies.size() != Globals.recipies.size():
					if Globals.current_recipie == recipie:
						Globals.current_recipie = Globals.recipies.pick_random()
					elif Globals.current_recipie != recipie:
						Globals.minigame = 1
				else:
					Globals.minigame_over = true
		else:
			$Label.text = "Required ingredient = {ingredient}".format({"ingredient":ingredient})
			if Input.is_action_just_pressed("Left Click"):
				if inragu:
					raguud = true
					sauced = false
					pastaed = false
				if insauce:
					raguud = false
					sauced = true
					pastaed = false
				if inpasta:
					raguud = false
					sauced = false
					pastaed = true
				
				if intray:
					if sauced:
						$Tray/Sprite2D.play("Bechamel")
						if ingredient == "Bechamel":
							Globals.gorefield_appeasment += 1
						else:
							Globals.gorefield_appeasment -= 4
						order.pop_front()
					if raguud:
						$Tray/Sprite2D.play("Ragu")
						if ingredient == "Ragu":
							Globals.gorefield_appeasment += 1
						else:
							Globals.gorefield_appeasment -= 4
						order.pop_front()
					if pastaed:
						$Tray/Sprite2D.play("Pasta")
						if ingredient == "Pasta":
							Globals.gorefield_appeasment += 1
						else:
							Globals.gorefield_appeasment -= 4
						order.pop_front()



func _on_tray_mouse_entered() -> void:
	if Globals.minigame == 4 and Globals.current_recipie == "Lasagne":
		intray = true
func _on_tray_mouse_exited() -> void:
	intray = false

func _on_ragu_mouse_entered() -> void:
	if Globals.minigame == 4 and Globals.current_recipie == "Lasagne":
		inragu = true
func _on_ragu_mouse_exited() -> void:
	inragu = false

func _on_bechamel_sauce_mouse_entered() -> void:
	if Globals.minigame == 4 and Globals.current_recipie == "Lasagne":
		insauce = true
func _on_bechamel_sauce_mouse_exited() -> void:
	insauce = false

func _on_pasta_mouse_entered() -> void:
	if Globals.minigame == 4 and Globals.current_recipie == "Lasagne":
		inpasta = true
func _on_pasta_mouse_exited() -> void:
	inpasta = false
