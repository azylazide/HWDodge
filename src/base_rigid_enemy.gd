extends RigidBody2D
class_name BaseRigidEnemy

@export var max_speed:= 200.0
@export var max_fall_speed:= 500.0

@export var knockback_speed:=100.0

var invincible:= false:
	set(val):
		if val:
			modulate = modulate.darkened(0.5)
		else:
			modulate = default_color

@onready var parrybox: ParryBox = $ParryBox

@onready var player: Player = get_tree().get_nodes_in_group("player")[0]

@onready var state_machine: StateMachine = $StateMachine

var default_color = modulate

func _ready() -> void:
	parrybox.request_knockback.connect(apply_knockback)
	state_machine.machine_init()

func _draw() -> void:
	draw_line(Vector2.ZERO,Vector2.ZERO.direction_to(to_local(player.global_position))*100,Color.GREEN)

func _physics_process(delta: float) -> void:
	state_machine.machine_physics(delta)
	queue_redraw()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state_machine.machine_forces(state)

func apply_knockback(knockback_direction: Vector2) -> void:
	print(knockback_direction)
	state_machine.machine_interrupt("hurt")
	var impulse:= knockback_speed*Vector2.UP.rotated(sign(knockback_direction.x)*PI/4)
	apply_central_impulse(impulse)
