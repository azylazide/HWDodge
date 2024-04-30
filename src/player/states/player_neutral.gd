extends PlayerState
class_name PlayerNeutral

@export_group("Transitions")
@export var lowkick: State = null
@export var normalkick: State = null
@export var highkick: State = null

func state_physics(delta: float) -> State:
	if Input.is_action_pressed("down"):
		player.down_buffer = true

	return null

func state_input(event: InputEvent) -> State:

	if event.is_action_released("down"):
		player.low_kick_commit_timer.start()

	if event.is_action_pressed("kick"):
		return lowkick

	return null
