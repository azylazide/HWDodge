extends CharacterBody2D
class_name Player

@export_category("Movement Values")
## Run speed in tiles per second
@export var max_run_tile:= 6.25
## Terminal fall speed in tiles per second
@export var max_fall_tile:= 15.0
## Jump speed in tiles per second
@export var jump_height:= 5.5
## Interrupted jump speed in tiles per second
@export var min_jump_height:= 0.5
## Max length of gap for a leap
@export var gap_length:= 12.5

@export_group("Initial Values")
## Change the initial facing direction
@export_enum("LEFT","RIGHT") var initial_direction:= 1
## Initial movement state on ready
@export var initial_movement_state: PlayerState
## Initial action state on ready
@export var initial_action_state: PlayerState

@export_category("Platformer Values")
## Stores player specific movement related parameters
@export var platformer_settings: PlatformerResource

## If on floor on current frame
var on_floor: bool

## Current direction of movement
var direction: float
## Current facing direction
var face_direction: float
## Movement speed
var speed: float
## Jump speed
var jump_force: float

## Gravity applied to the player when in jump state
var jump_gravity: float
## Jump speed applied for interrupted jumping
var min_jump_force: float
## Gravity apllied to the player when falling
var fall_gravity: float
## Max fall speed
var max_fall_speed: float
## Horizontal speed applied to dash states
var dash_force: float

## Statemachine
@onready var movement_sm: StateMachine = $StateMachineHolder/PlayerStateMachine

## Jump buffer timer
@onready var jump_buffer_timer:= $Timers/JumpBufferTimer as Timer

## Dash duration timer
@onready var dash_timer:= $Timers/DashTimer as Timer

## Dash duration timer
@onready var dash_jump_buffer_timer:= $Timers/DashJumpBufferTimer as Timer

## Dash cooldown duration timer
@onready var dash_cooldown_timer:= $Timers/DashCooldownTimer as Timer

## If on floor on previous frame
@onready var was_on_floor:= true

## Air dash is allowed
@onready var can_adash:= true

## Double jump is allowed
@onready var can_ajump:= true

## Setup movement values
func _setup_movement() -> void:
	jump_gravity = Utils._gravity(jump_height,max_run_tile,gap_length)
	fall_gravity = Utils._gravity(1.5*jump_height,max_run_tile,0.8*gap_length)

	jump_force = Utils._jump_vel(max_run_tile,jump_height,gap_length)
	min_jump_force = Utils._jump_vel(max_run_tile,min_jump_height,gap_length/2.0)
	max_fall_speed = max_fall_tile*Utils.TILE_UNITS

	speed = max_run_tile*Utils.TILE_UNITS

	dash_force = Utils._dash_speed(platformer_settings.dash_length,platformer_settings.dash_time)

	face_direction = 1

## Setup timer durations
func _setup_timers() -> void:
	jump_buffer_timer.wait_time = platformer_settings.jump_buffer_time
	dash_timer.wait_time = platformer_settings.dash_time
	dash_jump_buffer_timer.wait_time = platformer_settings.dash_jump_buffer_time
	dash_cooldown_timer.wait_time = platformer_settings.dash_cooldown_time

	#attack_charge_timer.wait_time = attack_charge_time

func _ready() -> void:
	_setup_movement()
	_setup_timers()
	#_setup_anim()

	movement_sm.initial_state = initial_movement_state
	movement_sm.machine_init()
	#action_sm.machine_init()

func _physics_process(delta: float) -> void:
	movement_sm.machine_physics(delta)
	#action_sm.machine_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	movement_sm.machine_input(event)
	#action_sm.machine_input(event)

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	movement_sm.machine_on_animation_signaled(anim_name)
	#action_sm.machine_on_animation_signaled(anim_name)


## Returns current input direction
func get_direction() -> float:
	return Input.get_axis("left","right")

## Applies move and slide and updates face_direction
func apply_movement(dir: float) -> void:
	move_and_slide()

	if dir == 0:
		return
	else:
		face_direction = -1 if dir < 0 else 1

## Checks floor or in coyote time
func check_floor() -> bool:
	return is_on_floor()

## Calculate gravity applied depending on areal state
func apply_gravity(delta: float) -> void:
	if velocity.y > 0:
		velocity.y += fall_gravity*delta

	else:
		velocity.y += jump_gravity*delta

	velocity.y = minf(velocity.y,max_fall_speed)

func ground_reset() -> void:
	can_ajump = true
	can_adash = true

func jump_reset() -> void:
	jump_buffer_timer.stop()
