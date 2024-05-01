extends PlayerState
class_name PlayerKick

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
var prev_attack: StringName = &""

func state_enter() -> void:
	super()
	prev_attack = &""

func state_physics(delta: float) -> State:
	return null

func state_input(event: InputEvent) -> State:
	if event.is_action_released("kick") and not is_attacking:
		machine.partner.change_state(nonestate)

		if machine.partner.previous_state in [idle,run]:
			if player.down_buffer:
				is_attacking = true
				player.anim_sm.travel(&"lowkick")
				player.reset_kick_timer()
				prev_attack = &"lowkick"
			else:
				if not player.high_kick_buffer_timer.is_stopped():
					is_attacking = true
					player.anim_sm.travel(&"highkick")
					player.reset_kick_timer()
					prev_attack = &"highkick"
				else:
					is_attacking = true
					player.anim_sm.travel(&"normalkick")
					prev_attack = &"normalkick"
		elif machine.partner.previous_state in [jump,fall,gdash]:
			if machine.partner.previous_state == fall and not player.top_kick_buffer_timer.is_stopped():
				is_attacking = true
				player.anim_sm.travel(&"topkick")
				player.reset_kick_timer()
				prev_attack = &"topkick"
			else:
				is_attacking = true
				player.anim_sm.travel(&"highkick")
				prev_attack = &"highkick"
		elif machine.partner.previous_state in [ajump,adash]:
			is_attacking = true
			player.anim_sm.travel(&"topkick")
			prev_attack = &"topkick"

	return null

func state_animated(anim_name: StringName) -> State:
	if anim_name in [&"lowkick",&"normalkick"]:
		machine.partner.change_state(machine.partner.previous_state)
		is_attacking = false
		return neutral
	elif anim_name in [&"highkick",&"topkick"]:
		machine.partner.change_state(fall)
		is_attacking = false
		return neutral
	return null

func state_exit() -> void:
	player.kick_cooldown_timer.start()
