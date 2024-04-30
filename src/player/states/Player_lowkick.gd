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
@export var nonestate: State = null

var is_attacking:= false

func state_enter() -> void:
	super()

func state_physics(delta: float) -> State:
	return null

func state_input(event: InputEvent) -> State:
	if event.is_action_released("kick") and not is_attacking:
		machine.partner.change_state(nonestate)

		if machine.partner.previous_state in [idle,run]:
			if player.down_buffer:
				is_attacking = true
				player.anim_sm.travel("lowkick")
				player.reset_kick_timer()
			else:
				is_attacking = true
				player.anim_sm.travel("normalkick")

	return null

func state_animated(anim_name: StringName) -> State:
	if anim_name in [&"lowkick",&"normalkick"]:
		machine.partner.change_state(machine.partner.previous_state)
		is_attacking = false
		return neutral
	return null
