extends CharacterBody3D
class_name BanditRiderAI

@export var patrol_points: Array[NodePath]
@export var patrol_speed: float = 8.0
@export var chase_speed: float = 13.0
@export var detect_range: float = 35.0
@export var target_path: NodePath

var current_index: int = 0
var target: Node3D

func _ready() -> void:
	target = get_node_or_null(target_path)

func _physics_process(delta: float) -> void:
	if target and global_position.distance_to(target.global_position) < detect_range:
		_move_to(target.global_position, chase_speed, delta)
	else:
		_patrol(delta)

func _patrol(delta: float) -> void:
	if patrol_points.is_empty():
		return
	var patrol_target := get_node_or_null(patrol_points[current_index]) as Node3D
	if not patrol_target:
		return
	if global_position.distance_to(patrol_target.global_position) < 2.0:
		current_index = (current_index + 1) % patrol_points.size()
	_move_to(patrol_target.global_position, patrol_speed, delta)

func _move_to(destination: Vector3, speed: float, _delta: float) -> void:
	var to_target := destination - global_position
	to_target.y = 0.0
	if to_target.length() < 0.1:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	var move_dir := to_target.normalized()
	velocity = move_dir * speed
	look_at(global_position + move_dir, Vector3.UP)
	move_and_slide()
