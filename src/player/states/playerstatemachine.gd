extends StateMachine
class_name PlayerStateMachine

@export var partner: StateMachine

func _physics_process(delta: float) -> void:
	#print(current_state)
	pass

func change_state(new_state: State) -> void:
	super(new_state)
