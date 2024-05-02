extends Line2D

const SPEED: float = 500

@export var direction:= 1

signal arrow_hit(area: Area2D)

func _physics_process(delta: float) -> void:
	global_position.x += SPEED*delta*direction

func _on_area_2d_area_entered(area: Area2D) -> void:
	arrow_hit.emit(area)


func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
