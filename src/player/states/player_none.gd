extends PlayerState

@export_group("Transitions")
@export var idle: State = null
@export var run: State = null
@export var fall: State = null
@export var jump: State = null
@export var gdash: State = null
@export var ajump: State = null
@export var adash: State = null
@export var nonestate: State = null

@export_group("References")
@export var kick: State = null
@export var bow: State = null
@export var stagger: State = null

func state_enter() -> void:
	# kick state controlled enter
	# apply residual motions
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

	elif machine.partner.current_state == bow:
		# small step back
		if machine.previous_state == idle:
			player.velocity.x = -player.face_direction*200
		elif machine.previous_state in [run,gdash]:
			if abs(player.velocity.x) > 0:
				player.velocity.x = -player.face_direction*300
		# apply residual motion
		elif machine.previous_state in [jump,fall,ajump]:
			player.velocity.y = 0
			if abs(player.velocity.x) > 0:
				player.velocity.x = -player.face_direction*200
		elif machine.previous_state == adash:
			if abs(player.velocity.x) > 0:
				player.velocity.x = -player.face_direction*300

	elif machine.partner.current_state == stagger:
		player.velocity = Vector2(-player.face_direction,-1).normalized()*400


func state_physics(delta: float) -> State:
	# kick state controlled physics
	if machine.partner.current_state == kick:
		if machine.previous_state in [jump,fall,gdash,adash,ajump]:
			# apply residual motion
			if not player.is_kick_frame:
				if abs(player.velocity.x) > 0:
					player.velocity.x = lerpf(player.velocity.x,0,0.15)

				player.was_on_floor = player.check_floor()
				player.apply_movement(player.face_direction)
				player.on_floor = player.check_floor()
			# apply small knockback
			elif player.is_kick_connected and player.is_kick_frame:
				player.velocity.x = -player.face_direction*100

				player.was_on_floor = player.check_floor()
				player.apply_movement(player.face_direction)
				player.on_floor = player.check_floor()
		elif machine.previous_state in [idle,run]:
			# apply small knockback
			if player.is_kick_connected and player.is_kick_frame:
				player.velocity.x = -player.face_direction*100

				player.was_on_floor = player.check_floor()
				player.apply_movement(player.face_direction)
				player.on_floor = player.check_floor()
				pass

	elif machine.partner.current_state == bow:
		if machine.previous_state in [idle,run,gdash]:
			if not player.is_bow_charged:
				player.was_on_floor = player.check_floor()
				player.apply_movement(player.face_direction)
				player.on_floor = player.check_floor()
		elif machine.previous_state in [fall,jump,ajump,adash]:
			if not player.is_bow_charged:
				player.was_on_floor = player.check_floor()
				player.apply_movement(player.face_direction)
				player.on_floor = player.check_floor()

	elif machine.partner.current_state == stagger:
		player.velocity.y += 0.1*player.fall_gravity*delta

		player.was_on_floor = player.check_floor()
		player.apply_movement(player.face_direction)
		player.on_floor = player.check_floor()

	return null

func state_exit() -> void:
	# stagger hasnt received the change state yet
	if machine.partner.current_state == stagger:
		player.velocity.x = 0
		player.velocity.y = maxf(player.velocity.y,0)

	elif machine.partner.current_state == kick:
		player.is_kick_connected = false

func state_animated(anim_name: StringName) -> State:
	if anim_name in [&"left_stagger",&"right_stagger"]:
		if player.on_floor:
			if player.get_direction():
				return run
			else:
				return idle
		return fall

	return null
