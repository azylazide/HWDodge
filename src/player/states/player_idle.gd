extends PlayerState
class_name PlayerIdle

@export_group("Transitions")
@export var run: State = null
@export var jump: State = null
@export var fall: State = null
@export var gdash: State = null


func state_enter() -> void:
	super()
	player.ground_reset()
	player.animplayer.play("idle")
	#player.anim_sm.travel("idle")
	player.velocity = Vector2.ZERO

func state_physics(delta: float) -> State:

	var direction:= player.get_direction()
	player.velocity.x = player.speed*direction

	player.was_on_floor = player.check_floor()
	player.apply_movement(direction)
	player.on_floor = player.check_floor()

	if player.face_direction < 0:
		player.sprite.flip_h = true
	elif player.face_direction > 0:
		player.sprite.flip_h = false

	if not player.on_floor:
		if not player.was_on_floor:
			return fall

	if not player.jump_buffer_timer.is_stopped():
		return jump

	if direction:
		return run

	return null

func state_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump"):
		return jump
	elif event.is_action_pressed("dash"):
		if player.dash_cooldown_timer.is_stopped():
			return gdash

	return null

func state_animated(anim_name: StringName) -> State:
	return null
