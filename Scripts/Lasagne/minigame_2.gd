extends Node2D

var speed = 0.3
var in_green = false
var in_yellow = false
var in_red = false
var in_orange = false
var ingredients = 6
@onready var arrow = $Path2D/PathFollow2D/Arrow
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.minigame == 2 and Globals.current_recipie == "Lasagne":
		$Path2D/PathFollow2D.progress_ratio += delta * speed
		if ingredients <= 0:
			Globals.minigame += 1
		if in_green and Input.is_action_just_pressed("Space"):
			Globals.gorefield_appeasment += 2
			ingredients -= 1
			arrow.play("Green")
			
		if in_yellow and Input.is_action_just_pressed("Space"):
			Globals.gorefield_appeasment += 1
			ingredients -= 1
			arrow.play("Yellow")
		if in_orange and Input.is_action_just_pressed("Space"):
			Globals.gorefield_appeasment -= 1
			ingredients -= 1
			arrow.play("Orange")
		if in_red and Input.is_action_just_pressed("Space"):
			Globals.gorefield_appeasment -= 2
			ingredients -= 1
			arrow.play("Red")
func _on_green_area_entered(area: Area2D) -> void:
	if Globals.minigame == 2 and Globals.current_recipie == "Lasagne":
		in_green = true

func _on_green_area_exited(area: Area2D) -> void:
	if Globals.minigame == 2:
		in_green = false

func _on_yellow_area_entered(area: Area2D) -> void:
	if Globals.minigame == 2:
		in_yellow = true

func _on_yellow_area_exited(area: Area2D) -> void:
	if Globals.minigame == 2:
		in_yellow = false

func _on_red_area_entered(area: Area2D) -> void:
	if Globals.minigame == 2:
		in_red = true

func _on_red_area_exited(area: Area2D) -> void:
	if Globals.minigame == 2:
		in_red = false

func _on_orange_area_entered(area: Area2D) -> void:
	if Globals.minigame == 2:
		in_orange = true

func _on_orange_area_exited(area: Area2D) -> void:
	if Globals.minigame == 2:
		in_orange = false

func _on_arrow_animation_finished() -> void:
	arrow.play("Moving")
