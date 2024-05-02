extends PlayerState
class_name PlayerBow

@export_group("Transitions")
@export var neutral: State = null
@export var stagger: State = null

@export_group("References")
@export var idle: State = null
@export var run: State = null
@export var fall: State = null
@export var jump: State = null
@export var gdash: State = null
@export var ajump: State = null
@export var adash: State = null
@export var nonestate: State = null


# actively attacking
var is_attacking:= false
var prev_attack: StringName = &""

func state_enter() -> void:
	super()
	prev_attack = &""

func state_physics(delta: float) -> State:
	return null

func state_input(event: InputEvent) -> State:
	if event.is_action_released("bow") and not is_attacking:
		# movement states immediately transition
		# movement states to check are previous
		machine.partner.change_state(nonestate)

		if machine.partner.previous_state == idle:
			is_attacking = true
			player.anim_sm.travel(&"idlebow")
			prev_attack = &"idlebow"
		elif machine.partner.previous_state in [run,gdash]:
			is_attacking = true
			player.anim_sm.travel(&"movebow")
			prev_attack = &"movebow"
		elif machine.partner.previous_state in [fall,jump,ajump,adash]:
			is_attacking = true
			player.anim_sm.travel(&"airbow")
			prev_attack = &"airbow"
		#elif machine.partner.previous_state in [jump,fall,gdash]:
			## topkick from buffer after ajump or adash
			#if machine.partner.previous_state == fall and not player.top_kick_buffer_timer.is_stopped():
				#is_attacking = true
				#player.anim_sm.travel(&"topkick")
				#player.reset_kick_timer()
				#prev_attack = &"topkick"
			#else:
				#is_attacking = true
				#player.anim_sm.travel(&"highkick")
				#prev_attack = &"highkick"
		#elif machine.partner.previous_state in [ajump,adash]:
			#is_attacking = true
			#player.anim_sm.travel(&"topkick")
			#prev_attack = &"topkick"

	return null

func state_animated(anim_name: StringName) -> State:
	if anim_name in [&"idlebow",&"movebow"]:
		machine.partner.change_state(idle)
		return neutral
	elif anim_name == &"airbow":
		machine.partner.change_state(fall)
		return neutral
	#elif anim_name in [&"highkick",&"topkick"]:
		#machine.partner.change_state(fall)
		#is_attacking = false
		#return neutral
	return null

func state_interrupt(message: String) -> State:
	if message == "hurt":
		return stagger
	return null

func state_exit() -> void:
	is_attacking = false
	player.bow_cooldown_timer.start()
	pass
