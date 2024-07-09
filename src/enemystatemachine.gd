extends StateMachine

func machine_forces(state: PhysicsDirectBodyState2D) -> void:
	if not is_instance_valid(current_state):
		return

	var new_state: State = current_state.state_forces(state)
	change_state(new_state)
