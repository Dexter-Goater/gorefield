extends Node3D

@onready var interaction_area = $InteractionArea
@onready var exit_position = $ExitPosition
@onready var locker_cam = $LockerCam # Optional

var is_occupied: bool = false
var player_ref: CharacterBody3D = null # Use KinematicBody3D in Godot 3

func _ready() -> void:
	$Label3D.hide()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body
		$Label3D.show()

func _on_body_exited(body):
	if body == player_ref:
		player_ref = null
		$Label3D.hide()

func _unhandled_input(event):
	if event.is_action_pressed("E"):
		if is_occupied:
			exit_locker()
		elif player_ref != null:
			enter_locker()

func enter_locker():
	is_occupied = true
	player_ref.is_hidden = true
	player_ref.process_mode = PROCESS_MODE_DISABLED
	player_ref.visible = false
	player_ref.global_transform.origin = global_transform.origin


func exit_locker():
	is_occupied = false
	player_ref.is_hidden = false
	player_ref.process_mode = PROCESS_MODE_INHERIT
	player_ref.visible = true
	player_ref.global_transform.origin = exit_position.global_transform.origin
