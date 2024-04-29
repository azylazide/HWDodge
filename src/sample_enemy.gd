extends RigidBody2D

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_O):
		apply_central_impulse(100*Vector2.RIGHT.rotated(-PI/4))
