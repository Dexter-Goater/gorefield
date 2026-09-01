extends Node
var minigame = 3
var gorefield_appeasment = 5
var recipies = ["Lasagne","Pizza"]
var current_recipie
var old_recipies = [""]
var minigame_over = false
var threed = false
var gens_active = 0
var distancetoplayer
var chasingplayer = false
var Chase_Indicator_max_distance := 100
var Chase_Indicator_min_distance := 2.0
var book_up = false
var countdownfin = false


@onready var label_left: Label = get_tree().current_scene.find_child("label_left", true, false)
@onready var label_right: Label = get_tree().current_scene.find_child("label_right", true, false)
var recipe_book := {
	"Pizza": {
		"1": ["Track the white dot with your cursor to stir the ingredients.", "Make sure to track it well or you will make him angry"],
		"2": ["Press the key given to you to knead the dough.", "Make sure to press the right key or you will make him angry"],
		"3": ["Click and drag inside the pizza to add sauce.", "Make sure to go quick or you will make him angry"],
		"4": ["Set the oven to 250 Degrees and set it to fan then click the oven to insert the pizza.", "Make sure to go quick or you will make him angry"],
	},
	"Lasagne": {
		"1": ["Spam Left click to chop the vegetables.", "Make sure to go quick or you will make him angry"],
		"2": ["Press the space bar when the arrow is over the green to drop ingredients into the pot.", "Make sure not to miss or you will make him angry"],
		"3": ["Track the white dot with your cursor to stir the ingredients.", "Make sure to track it well or you will make him angry"],
		"4": ["Left click on the correct ingredient then left click on the pan to add it.", "Make sure you add the ingredients in the correct order or you will make him angry"],
	},
}

func load_book_text() -> void:
	var recipe_key: String = current_recipie
	var step_key := str(minigame)

	if not recipe_book.has(recipe_key):
		push_warning("load_book_text: no recipe_book entry for '%s'" % recipe_key)
		return
	if not recipe_book[recipe_key].has(step_key):
		push_warning("load_book_text: no step entry for '%s' in recipe '%s'" % [step_key, recipe_key])
		return

	var pages: Array = recipe_book[recipe_key][step_key]
	label_left.text = pages[0]
	label_right.text = pages[1]

func showbook() -> void:
	var book := get_tree().current_scene.find_child("book", true, false)
	var close := get_tree().current_scene.find_child("close", true, false)
	if book:
		close.disabled = false
		book.visible = true
		label_left.visible = true
		label_right.visible = true
		load_book_text()
		book_up = true
		

func hidebook() -> void:
	var book := get_tree().current_scene.find_child("book", true, false)
	var close := get_tree().current_scene.find_child("close", true, false)
	if book:
		close.disabled = true
		book.visible = false
		label_right.visible = false
		label_left.visible = true
		book_up = false
		startcountdown()

func startcountdown():
	countdownfin = false
	var countdown := get_tree().current_scene.find_child("countdown", true, false)
	var timer := get_tree().current_scene.find_child("countdowntimer", true, false)
	var jhon := get_tree().current_scene.find_child("jhontimer", true, false)
	countdown.show()

	if not countdown or not timer or not jhon:
		push_warning("startcountdown: missing one or more required nodes")
		return

	timer.start()
	countdown.play("Count")

	if not timer.timeout.is_connected(_on_countdown_timeout):
		timer.timeout.connect(_on_countdown_timeout.bind(countdown, jhon))

func _on_countdown_timeout(countdown, jhon) -> void:
	jhon.start()
	countdown.play("Jhon")

	if not jhon.timeout.is_connected(_on_jhon_timeout):
		jhon.timeout.connect(_on_jhon_timeout)

func _on_jhon_timeout() -> void:
	countdownfin = true
	var countdown := get_tree().current_scene.find_child("countdown", true, false)
	countdown.hide()
