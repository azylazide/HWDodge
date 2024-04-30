extends PlayerState

@export_group("References")
@export var idle: State = null
@export var run: State = null
@export var fall: State = null
@export var jump: State = null
@export var gdash: State = null
@export var ajump: State = null
@export var adash: State = null
@export var nonestate: State = null
@export var kick: State = null

func state_enter() -> void:
	if machine.partner.current_state == kick:
		if machine.previous_state in [jump,fall]:
			player.velocity.y = 0
			if abs(player.velocity.x) > 0:
				player.velocity.x = player.face_direction*100

func state_physics(delta: float) -> State:
	if machine.partner.current_state == kick:
		if machine.previous_state in [jump,fall]:
			if player.anim_sm.get_current_play_position() <= 0.4:
				if abs(player.velocity.x) > 0:
					player.velocity.x = lerpf(player.velocity.x,0,0.15)

				player.was_on_floor = player.check_floor()
				player.apply_movement(player.face_direction)
				player.on_floor = player.check_floor()

	return null
