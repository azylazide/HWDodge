extends Area2D

func _on_area_entered(area: Area2D) -> void:
	Globals.request_slowdown(0.1,0.45)
