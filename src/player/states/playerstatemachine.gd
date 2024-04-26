extends StateMachine
class_name PlayerStateMachine

var partner: StateMachine

func _physics_process(delta: float) -> void:
	print(current_state)
