extends StateMachine
class_name PlayerStateMachine

@export var partner: StateMachine

func _physics_process(delta: float) -> void:
	#print(current_state)
	pass

func change_state(new_state: State) -> void:
	print_debug(self)
	print_stack()
	super(new_state)
