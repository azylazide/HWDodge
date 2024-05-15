extends State

@export_group("Transitions")
@export var knockback_state: State

func state_enter() -> void:
	print("chasing")

func state_physics(delta) -> State:
	var direction = pawn.global_position.direction_to(pawn.player.global_position)
	pawn.apply_central_force(sign(direction.x)*Vector2.RIGHT*50)
	return null

func state_forces(state: PhysicsDirectBodyState2D) -> State:
	state.linear_velocity = Vector2(clampf(state.linear_velocity.x,-pawn.max_speed,pawn.max_speed),state.linear_velocity.y)
	return null

func state_interrupt(message: String) -> State:
	if message == "hurt":
		return knockback_state

	return null
