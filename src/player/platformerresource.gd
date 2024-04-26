extends Resource
class_name  PlatformerResource

@export_subgroup("Jump")
## Coyote time to temporarily float in seconds
@export var coyote_time:= 0.1
## Time jump inputs are remembered just before landing from falling in seconds
@export var jump_buffer_time:= 0.1
## Multiplier for air jump speed
@export var air_jump_multiplier:= 0.8
## Multiplier for ground dash jump speed
@export var dash_jump_multiplier:= 1.2

@export_subgroup("Dash")
## Dash duration in seconds
@export var dash_time:= 0.2
## Jump buffer time for jumping just before air dash stops
@export var dash_jump_buffer_time:= 0.2
## Duration until player can dash again
@export var dash_cooldown_time:= 0.2
## Distance travelled by dash
@export var dash_length:= 4.0
