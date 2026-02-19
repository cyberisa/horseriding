extends Node
class_name SpeedShake

@export var trauma_decay: float = 1.3
@export var max_roll: float = 0.03
@export var max_offset: float = 0.14
@onready var camera: Camera3D = get_parent() as Camera3D

var trauma: float = 0.0
var base_position: Vector3

func _ready() -> void:
	base_position = camera.position

func _process(delta: float) -> void:
	trauma = max(0.0, trauma - trauma_decay * delta)
	var shake := trauma * trauma
	var t := Time.get_ticks_msec() * 0.001
	camera.rotation.z = sin(t * 20.0) * max_roll * shake
	camera.position = base_position + Vector3(
		sin(t * 30.0),
		cos(t * 24.0),
		0.0
	) * max_offset * shake

func on_speed_changed(speed: float, max_speed: float) -> void:
	if speed > max_speed * 0.7:
		trauma = min(1.0, trauma + 0.015)
