extends Node2D

@export var arrow_scn: PackedScene

@onready var player: Player = $Player

func _ready() -> void:
	player.bow_fired.connect(spawn_arrow)

func spawn_arrow(attack) -> void:
	var arrow_instance:= arrow_scn.instantiate()
	add_child(arrow_instance)
	arrow_instance.direction = player.face_direction
	arrow_instance.global_position = player.get_node("ArrowSpawn").global_position
