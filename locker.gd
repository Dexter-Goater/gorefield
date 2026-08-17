extends Node3D

@onready var interaction_area = $InteractionArea
@onready var exit_position = $ExitPosition
@onready var locker_cam = $LockerCam 

var is_occupied: bool = false
var player_ref: CharacterBody3D = null

func _ready() -> void:
	$Label3D.hide()

func _on_body_entered(body):
	if body.is_in_group("player") and Globals.gens_active != 3:
		player_ref = body
		$Label3D.show()

func _on_body_exited(body):
	if body == player_ref:
		$Label3D.hide()
		if not is_occupied:
			player_ref = null

func _unhandled_input(event):
	if event.is_action_pressed("E"):
		if is_occupied:
			exit_locker()
		elif player_ref != null:
			enter_locker()

func enter_locker():
	if player_ref == null:
		return
	is_occupied = true
	$Label3D.hide()
	if "camera" in Player and Player.camera:
		Player.camera.current = false
	get_node("Camera3D").current = true
	player_ref.is_hidden = true
	player_ref.process_mode = PROCESS_MODE_DISABLED
	player_ref.visible = false
	player_ref.global_transform.origin = global_transform.origin

func exit_locker():
	if player_ref == null:
		return
	is_occupied = false
	get_node("Camera3D").current = false
	if "camera" in Player and Player.camera:
		Player.camera.current = true
	player_ref.is_hidden = false
	player_ref.process_mode = PROCESS_MODE_INHERIT
	player_ref.visible = true
	player_ref.global_transform.origin = exit_position.global_transform.origin
	if interaction_area and not interaction_area.overlaps_body(player_ref):
		player_ref = null
