extends RigidBody2D

func _ready() -> void:
	$Area2D2.area_shape_entered.connect(knockback)

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_O):
		apply_central_impulse(100*Vector2.RIGHT.rotated(-PI/4))

func knockback(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:

	var other_shape_owner: int = area.shape_find_owner(area_shape_index)
	var other_shape_node: CollisionShape2D = area.shape_owner_get_owner(other_shape_owner)

	var local_shape_owner: int = shape_find_owner(local_shape_index)
	var local_shape_node: CollisionShape2D = shape_owner_get_owner(local_shape_owner)

	var knockback_direction = other_shape_node.global_position.direction_to(local_shape_node.global_position).project(Vector2.RIGHT).normalized().x
	if area is KickBox:
		print(area)
		printt(other_shape_node.global_position,local_shape_node.global_position)
		print(knockback_direction)
