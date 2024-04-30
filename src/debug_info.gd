extends Control

@onready var debug_position: Label = %Position
@onready var velocity: Label = %Velocity
@onready var movement_state: Label = %MovementState
@onready var action_state: Label = %ActionState
@onready var animation: Label = %Animation
@onready var animation_path: Label = %AnimationPath

func display_position(value: Vector2) -> void:
	debug_position.text = "Position: (%.00f,%.00f)" %[value.x,value.y]

func display_velocity(value: Vector2) -> void:
	velocity.text = "Velocity: (%.00f,%.00f)" %[value.x,value.y]

func display_movement_state(previous: State, current: State) -> void:
	var format = [previous.name if previous else &"None", current.name]
	movement_state.text = "Movement State\nprev: %s\ncurrent: %s" %format

func display_action_state(previous: State, current: State) -> void:
	var format = [previous.name if previous else &"None", current.name]
	action_state.text = "Action State\nprev: %s\ncurrent: %s" %format

func display_animation(anim_sm: AnimationNodeStateMachinePlayback) -> void:
	animation.text = "Anim: %s" %[anim_sm.get_current_node()]
	animation_path.text = "Path: %s (%s)" %[anim_sm.get_travel_path(),"Playing" if anim_sm.is_playing() else "Off"]
