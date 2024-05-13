extends RigidBody2D
class_name BaseRigidEnemy

@export var max_speed:= 200.0
@export var max_fall_speed:= 500.0

@export var knockback_speed:=100.0

var invincible:= false

@onready var parrybox: ParryBox = $ParryBox

func _ready() -> void:
	parrybox.request_knockback.connect(apply_knockback)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.angular_velocity = 0
	state.linear_velocity = Vector2(clampf(state.linear_velocity.x,-max_speed,max_speed),state.linear_velocity.y)

func apply_knockback(knockback_direction: Vector2) -> void:
	print(knockback_direction)
	apply_central_impulse(knockback_speed*knockback_direction.normalized())
