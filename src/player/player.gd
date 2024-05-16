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

@export_category("Player Values")
## Stores player specific movement related parameters
@export var platformer_settings: PlatformerResource

@export var player_details: PlayerDetailResource

signal bow_fired(bowtype: StringName)

## If on floor on current frame
var on_floor: bool

var anim_sm: AnimationNodeStateMachinePlayback

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
## Dash Input Buffer
var dash_buffer: float = 0

var dash_buffer_max: float

var inputbuffer: Array[InputEventKey] = []

var down_buffer:= false

var is_kick_connected:= false

var is_bow_charged:= false

var is_inside_enemy_hazard:= false

var is_invincible:= false

var invincibility_tween: Tween = null

var additional_velocity:= Vector2.ZERO

## Statemachine
@onready var movement_sm: StateMachine = $StateMachineHolder/PlayerStateMachine
@onready var action_sm: StateMachine = $StateMachineHolder/PlayerActionStateMachine

#region timers
## Jump buffer timer
@onready var jump_buffer_timer:= $Timers/JumpBufferTimer as Timer

## Dash duration timer
@onready var dash_timer:= $Timers/DashTimer as Timer

## Dash duration timer
@onready var dash_jump_buffer_timer:= $Timers/DashJumpBufferTimer as Timer

## Dash cooldown duration timer
@onready var dash_cooldown_timer:= $Timers/DashCooldownTimer as Timer

@onready var kick_commit_timer: Timer = $Timers/KickCommitTimer

@onready var low_kick_buffer_timer: Timer = $Timers/LowKickBufferTimer

@onready var kick_knockback_timer: Timer = $Timers/KickKnockbackTimer

@onready var kick_cooldown_timer: Timer = $Timers/KickCooldownTimer

@onready var high_kick_buffer_timer: Timer = $Timers/HighKickBufferTimer

@onready var top_kick_buffer_timer: Timer = $Timers/TopKickBufferTimer

@onready var bow_cooldown_timer: Timer = $Timers/BowCooldownTimer

@onready var invincibility_timer: Timer = $Timers/InvincibilityTimer

#endregion

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var animplayer: AnimationPlayer = $AnimationPlayer

@onready var anim_tree: AnimationTree = $AnimationTree

@onready var dodgebox: Area2D = $Dodgebox

@onready var kick_box: Area2D = $KickBox

@onready var hurtbox: Area2D = $Hurtbox

## If on floor on previous frame
@onready var was_on_floor:= true

## Air dash is allowed
@onready var can_adash:= true

## Double jump is allowed
@onready var can_ajump:= true

@onready var is_kick_frame:= false

## Setup movement values
func _setup_movement() -> void:
	jump_gravity = Utils._gravity(jump_height,max_run_tile,gap_length)
	fall_gravity = Utils._gravity(1.5*jump_height,max_run_tile,0.8*gap_length)

	jump_force = Utils._jump_vel(max_run_tile,jump_height,gap_length)
	min_jump_force = Utils._jump_vel(max_run_tile,min_jump_height,gap_length/2.0)
	max_fall_speed = max_fall_tile*Utils.TILE_UNITS

	speed = max_run_tile*Utils.TILE_UNITS

	dash_force = Utils._dash_speed(platformer_settings.dash_length,platformer_settings.dash_time)

	face_direction = float(2*initial_direction-1)

## Setup timer durations
func _setup_timers() -> void:
	jump_buffer_timer.wait_time = platformer_settings.jump_buffer_time
	dash_timer.wait_time = platformer_settings.dash_time
	dash_jump_buffer_timer.wait_time = platformer_settings.dash_jump_buffer_time
	dash_cooldown_timer.wait_time = platformer_settings.dash_cooldown_time

	#attack_charge_timer.wait_time = attack_charge_time
	low_kick_buffer_timer.timeout.connect(func(): down_buffer = false)
	low_kick_buffer_timer.wait_time = platformer_settings.low_kick_buffer_time
	kick_knockback_timer.wait_time = platformer_settings.kick_knockback_time
	kick_cooldown_timer.wait_time = platformer_settings.kick_cooldown_time
	high_kick_buffer_timer.wait_time = platformer_settings.high_kick_buffer_time
	top_kick_buffer_timer.wait_time = platformer_settings.top_kick_buffer_time

	bow_cooldown_timer.wait_time = platformer_settings.bow_cooldown_time

	invincibility_timer.timeout.connect(invincible_reset)
	invincibility_timer.wait_time = platformer_settings.invincibility_time

## Setup [AnimationTree]
func _setup_anim() -> void:
	anim_sm = anim_tree.get("parameters/playback")
	anim_tree.active = true

func _setup_other() -> void:
	kick_box.kick_connected.connect(func(): is_kick_connected = true; print("KICK CONNECTED"))
	dodgebox.area_entered.connect(func(area): is_inside_enemy_hazard = true)
	dodgebox.area_exited.connect(func(area): is_inside_enemy_hazard = false)
	hurtbox.area_entered.connect(func(hurtarea): hurt(hurtarea,hurtarea.damage_settings))

func _ready() -> void:
	_setup_movement()
	_setup_timers()
	_setup_anim()
	_setup_other()

	movement_sm.initial_state = initial_movement_state
	movement_sm.machine_init()
	action_sm.initial_state = initial_action_state
	action_sm.machine_init()

	add_to_group("player")

func _physics_process(delta: float) -> void:
	movement_sm.machine_physics(delta)
	action_sm.machine_physics(delta)
	resolve_animations()

	debug_info.call_deferred()

func _unhandled_input(event: InputEvent) -> void:
	movement_sm.machine_input(event)
	action_sm.machine_input(event)

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	movement_sm.machine_on_animation_signaled(anim_name)
	action_sm.machine_on_animation_signaled(anim_name)

## Returns current input direction
func get_direction() -> float:
	return Input.get_axis("left","right")

## Applies move and slide and updates face_direction
func apply_movement(dir: float) -> void:

	velocity += additional_velocity

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

func resolve_animations() -> void:
	var anim_list: Array[String] = [
		"idle","run","fall","jump",
		"dash",
		"stagger",
		"idlebow","movebow","airbow",
		"lowkick","normalkick","highkick","topkick"]
	for anim_name in anim_list:
		anim_tree.set("parameters/%s/blend_position" %anim_name,face_direction)
		pass

func reset_kick_timer() -> void:
	low_kick_buffer_timer.stop()
	top_kick_buffer_timer.stop()
	high_kick_buffer_timer.stop()
	down_buffer = false

## Kick check controlled by animation to determine if currently in kick frames of the animation
func kick_check(check: bool) -> void:
	is_kick_frame = check

## Enable or disable monitoring/monitorable of [KickBox]
func kick_toggle(toggle: bool) -> void:
	kick_box.set_monitorable.call_deferred(toggle)
	kick_box.set_monitoring.call_deferred(toggle)

## Bow charge check controlled by animation to determine if currently in charge frames of the animation
func bow_charge_check(check: bool) -> void:
	is_bow_charged = true

## Fire bow as controlled by animation
func fire_bow() -> void:
	bow_fired.emit(action_sm.current_state.prev_attack)
	is_bow_charged = false

## [Hurtbox] controlled function to transition to hurt state
func hurt(hazard: Area2D, damage: DamageResource) -> void:
	if not is_invincible:
		printt("hurt",hazard,damage.damage_applied)
		face_direction = -signf(hazard.get_node("CollisionShape2D").global_position.direction_to(hurtbox.global_position).x)
		action_sm.machine_interrupt("hurt")
		hurtbox.set_monitoring.call_deferred(false)

## [Timer] controlled function to reset invincibility conditions
func invincible_reset() -> void:
	is_invincible = false
	invincibility_tween.kill()
	sprite.modulate.a = 1
	hurtbox.set_monitoring.call_deferred(true)

func invicibility_frames() -> Tween:
	var tween = create_tween().set_loops()
	tween.tween_property(sprite,"modulate:a",0.2,0.15)
	tween.tween_property(sprite,"modulate:a",1,0.15)
	return tween

func debug_info() -> void:
	DebugInfo.display_position(global_position)
	DebugInfo.display_velocity(velocity)
	DebugInfo.display_movement_state(movement_sm)
	DebugInfo.display_action_state(action_sm)
	DebugInfo.display_animation(anim_sm)
	DebugInfo.display_timers([bow_cooldown_timer,invincibility_timer])
