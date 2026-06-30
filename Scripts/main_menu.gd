extends Node2D
var inplay = false
var inquit = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_mouse_entered() -> void:
	inplay = true


func _on_play_mouse_exited() -> void:
	inplay = false


func _on_quit_mouse_entered() -> void:
	inquit = true


func _on_quit_mouse_exited() -> void:
	inquit = false
