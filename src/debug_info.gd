extends Control

@onready var debug_position: Label = %Position
@onready var velocity: Label = %Velocity
@onready var movement_state: Label = %MovementState
@onready var action_state: Label = %ActionState
@onready var animation: Label = %Animation
@onready var animation_path: Label = %AnimationPath
@onready var timer_labels: Label = %TimerLabels

func display_position(value: Vector2) -> void:
	debug_position.text = "Position: (%.00f,%.00f)" %[value.x,value.y]

func display_velocity(value: Vector2) -> void:
	velocity.text = "Velocity: (%.00f,%.00f)" %[value.x,value.y]

func display_movement_state(statemachine: StateMachine) -> void:
	var state_names: Array[String] = []
	for s in statemachine.state_history:
		state_names.append(s.name)
	var format = [statemachine.previous_state.name if statemachine.previous_state else &"None", statemachine.current_state.name,state_names]
	movement_state.text = "Movement State\nprev: %s\ncurrent: %s\n%s" %format

func display_action_state(statemachine: StateMachine) -> void:
	var state_names: Array[String] = []
	for s in statemachine.state_history:
		state_names.append(s.name)
	var format = [statemachine.previous_state.name if statemachine.previous_state else &"None", statemachine.current_state.name,state_names]
	action_state.text = "Action State\nprev: %s\ncurrent: %s\n%s" %format

func display_animation(anim_sm: AnimationNodeStateMachinePlayback) -> void:
	animation.text = "Anim: %s" %[anim_sm.get_current_node()]
	animation_path.text = "Path: %s (%s)" %[anim_sm.get_travel_path(),"Playing" if anim_sm.is_playing() else "Off"]

func display_timers(timers: Array[Timer]) -> void:
	var format = []
	for timer in timers:
		format.append(timer.name)
		format.append(timer.time_left)

	var placement_string = ""
	for i in format.size()/2:
		placement_string = placement_string+"%s:%0.2f"+"\n"

	timer_labels.text = "Timers: Time Remaining\n"+placement_string % format
