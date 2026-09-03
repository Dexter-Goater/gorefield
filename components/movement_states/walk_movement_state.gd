class_name WalkMovementState
extends MovementState
var _speed : float
var _is_sprinting : bool = false

func _enter_state() -> void:
	_speed = machine.target.walk_speed
	_is_sprinting = false



func _update_state_unhandled_input(event : InputEvent) -> void:
	if machine.has_jump() and event.is_action_pressed(machine.jump_action):
		machine.change_state(machine.jump_state)
	if machine.has_sprint() and event.is_action_pressed(machine.sprint_action):
		if machine.target.can_sprint():
			_speed = machine.target.sprint_speed
			_is_sprinting = true
	if machine.has_sprint() and event.is_action_released(machine.sprint_action):
		_speed = machine.target.walk_speed
		_is_sprinting = false

func _update_state_physics(_delta : float) -> void:
	if _is_sprinting and not machine.target.can_sprint():
		_speed = machine.target.walk_speed
		_is_sprinting = false
	if machine.target._direction:
		machine.target.velocity.x = machine.target._direction.x * _speed 
		machine.target.velocity.z = machine.target._direction.z * _speed 
	else:
		machine.change_state(machine.idle_state)
