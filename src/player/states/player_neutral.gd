extends PlayerState
class_name PlayerNeutral

@export_group("Transitions")
@export var kick: State = null
@export var bow: State = null

func state_physics(delta: float) -> State:
	if Input.is_action_pressed("down"):
		player.down_buffer = true

	return null

func state_input(event: InputEvent) -> State:
	if event.is_action_released("dash"):
		player.top_kick_buffer_timer.start()
		player.high_kick_buffer_timer.start()

	if event.is_action_released("down"):
		player.low_kick_buffer_timer.start()

	if event.is_action_pressed("kick") and player.kick_cooldown_timer.is_stopped():
		return kick

	if event.is_action_pressed("bow") and player.bow_cooldown_timer.is_stopped():
		return bow

	return null
