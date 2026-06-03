extends Node2D
var order = ["Ragu","Pasta","Ragu","Bechamel","Pasta","Ragu","Bechamel","Pasta","Ragu","Bechamel","Pasta","Ragu","Bechamel","Pasta","Ragu","Bechamel"]
var intray = false
var inragu = false
var insauce = false
var inpasta = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Left Click") and Globals.minigame == 4:
		var ingredient = order[0]
		$Label.text = "Required ingredient = {ingredient}".format({"ingredient":ingredient})
		order.erase(ingredient)


func _on_tray_mouse_entered() -> void:
	if Globals.minigame == 4:
		intray = true
func _on_tray_mouse_exited() -> void:
	intray = false

func _on_ragu_mouse_entered() -> void:
	if Globals.minigame == 4:
		inragu = true
func _on_ragu_mouse_exited() -> void:
	intray = false

func _on_bechamel_sauce_mouse_entered() -> void:
	if Globals.minigame == 4:
		insauce = true
func _on_bechamel_sauce_mouse_exited() -> void:
	insauce = false

func _on_pasta_mouse_entered() -> void:
	if Globals.minigame == 4:
		inpasta = true
func _on_pasta_mouse_exited() -> void:
	inpasta = false
