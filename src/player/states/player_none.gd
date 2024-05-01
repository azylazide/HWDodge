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
		elif machine.previous_state in [gdash,adash]:
			if abs(player.velocity.x) > 0:
				player.velocity.x = player.face_direction*150
		elif machine.previous_state == ajump:
			player.velocity.y = -player.min_jump_force

func state_physics(delta: float) -> State:
	if machine.partner.current_state == kick:
		if machine.previous_state in [jump,fall,gdash,adash,ajump]:
			if not player.is_kick_frame:
				if abs(player.velocity.x) > 0:
					player.velocity.x = lerpf(player.velocity.x,0,0.15)

				player.was_on_floor = player.check_floor()
				player.apply_movement(player.face_direction)
				player.on_floor = player.check_floor()

	return null
