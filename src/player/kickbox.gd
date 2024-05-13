extends Area2D
class_name KickBox

signal kick_connected


func _on_area_entered(area: Area2D) -> void:
	print(area)
	kick_connected.emit()
	Globals.request_slowdown(0.1,0.45)
