extends Node

func request_slowdown(timescale: float,duration: float) -> void:
	Engine.time_scale = timescale
	await get_tree().create_timer(duration*timescale).timeout
	Engine.time_scale = 1
