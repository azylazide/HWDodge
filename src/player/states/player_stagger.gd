extends PlayerState

@export_group("Transitions")
@export var neutral: State = null

@export_group("References")
@export var nonestate: State = null

func state_enter() -> void:
	Globals.request_slowdown(0.1,0.4)
	player.anim_sm.travel(&"stagger")
	player.is_invincible = true
	machine.partner.change_state(nonestate)

func state_animated(anim_name: StringName) -> State:
	player.invincibility_timer.start()
	player.invincibility_tween = player.invicibility_frames()
	return neutral
