extends Node3D
class_name ThirdPersonCameraRig

@export var target_path: NodePath
@export var follow_distance: float = 8.0
@export var follow_height: float = 3.2
@export var follow_lerp: float = 6.0
@export var look_lerp: float = 8.0
@export var lag_amount: float = 0.15

@onready var camera: Camera3D = $Camera3D
var target: Node3D
var velocity_bias := Vector3.ZERO

func _ready() -> void:
	target = get_node_or_null(target_path)

func _process(delta: float) -> void:
	if not target:
		return

	var desired_back := target.global_transform.basis.z * follow_distance
	var desired_pos := target.global_position + Vector3.UP * follow_height + desired_back
	velocity_bias = velocity_bias.lerp(target.get("velocity") * lag_amount, 4.0 * delta)
	desired_pos += velocity_bias

	global_position = global_position.lerp(desired_pos, follow_lerp * delta)
	var desired_look := target.global_position + Vector3.UP * 1.6
	camera.global_transform = camera.global_transform.interpolate_with(
		Transform3D(camera.global_transform.basis, global_position),
		follow_lerp * delta
	)
	camera.look_at(camera.global_position.lerp(desired_look, look_lerp * delta), Vector3.UP)
