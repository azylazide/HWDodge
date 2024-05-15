extends State

@export_group("Transitions")
@export var chase: State

var recovered:= false

func state_enter() -> void:
	print("enemy knockbacked")
	await get_tree().create_timer(1.5).timeout
	machine.machine_interrupt("recover")

func state_physics(delta) -> State:
	return null

func state_forces(state: PhysicsDirectBodyState2D) -> State:
	state.linear_velocity = Vector2(clampf(state.linear_velocity.x,-pawn.max_speed,pawn.max_speed),state.linear_velocity.y)
	pawn.physics_material_override.friction = 0.1
	if recovered:
		state.linear_velocity = Vector2.ZERO
		pawn.physics_material_override.friction = 0
		return chase
	return null

func state_interrupt(message: String) -> State:
	if message == "recover":
		recovered = true
	return null

func state_exit() -> void:
	recovered = false
	pass
