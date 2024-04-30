extends PlayerState
class_name PlayerLowKick

@export_group("Transitions")
@export var neutral: State = null

@export_group("References")
@export var idle: State = null
@export var run: State = null
@export var fall: State = null
@export var jump: State = null
@export var gdash: State = null
@export var ajump: State = null
@export var adash: State = null

func state_enter() -> void:
	super()

func state_physics(delta: float) -> State:
	return null

func state_input(event: InputEvent) -> State:
	if event.is_action_released("kick"):
		if machine.partner.current_state in [idle,run]:
			if player.down_buffer:
				print("LOWKICK")
				player.reset_kick_timer()
			else:
				print("NORMALKICK")
		return neutral

	return null

