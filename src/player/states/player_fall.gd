extends PlayerState
class_name PlayerFall

@export_group("Transitions")
@export var idle: State = null
@export var run: State = null
@export var jump: State = null
@export var adash: State = null
@export var ajump: State = null

@export_group("References")
@export var kick: State = null
@export var nonestate: State = null

var temp_direction:= 0

func state_enter() -> void:
	super()
	player.anim_sm.travel("fall")
	if machine.partner.current_state == kick and machine.previous_state == nonestate:
		if kick.prev_attack == &"topkick":
			temp_direction = player.face_direction
			player.top_kick_knockback_timer.start()
			player.velocity.y = -player.min_jump_force

func state_physics(delta: float) -> State:

	var direction:= player.get_direction()
	player.velocity.x = player.speed*direction

	if machine.partner.previous_state == kick and machine.previous_state == nonestate:
		if kick.prev_attack == &"topkick":
			if not player.top_kick_knockback_timer.is_stopped():
				player.velocity.x += 200*-temp_direction

	player.apply_gravity(delta)

	player.was_on_floor = player.check_floor()
	player.apply_movement(direction)
	player.on_floor = player.check_floor()

	if player.face_direction < 0:
		player.sprite.flip_h = true
	elif player.face_direction > 0:
		player.sprite.flip_h = false

	if player.on_floor:
		if direction:
			return run
		return idle

	return null

func state_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump"):
		if player.velocity.y > 0:
			player.jump_buffer_timer.start()

		if player.can_ajump:
			return ajump

	if event.is_action_pressed("dash"):
		if player.dash_cooldown_timer.is_stopped() and player.can_adash:
			return adash

	return null

func state_animated(anim_name: StringName) -> State:
	return null
