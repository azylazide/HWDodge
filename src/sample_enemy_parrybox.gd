extends Area2D
class_name ParryBox

var invincible:= false

func _ready() -> void:
	area_shape_entered.connect(knockback)

func knockback(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if invincible:
		return

	printt(area,Engine.get_process_frames())

	var other_shape_owner: int = area.shape_find_owner(area_shape_index)
	var other_shape_node: CollisionShape2D = area.shape_owner_get_owner(other_shape_owner)

	var local_shape_owner: int = shape_find_owner(local_shape_index)
	var local_shape_node: CollisionShape2D = shape_owner_get_owner(local_shape_owner)

	var knockback_direction = other_shape_node.global_position.direction_to(local_shape_node.global_position).project(Vector2.RIGHT).normalized().x
	if area is KickBox:
		print(area)
		printt(other_shape_node.global_position,local_shape_node.global_position,get_tree().get_frame())
		print(knockback_direction)
		invincible = true
		await get_tree().create_timer(3).timeout
		invincible = false
