extends CharacterBody3D
class_name HorseController

signal speed_changed(speed: float)
signal stamina_changed(current: float, max_value: float)
signal gallop_beat(strength: float)

@export_group("Movement")
@export var walk_speed: float = 5.0
@export var trot_speed: float = 10.0
@export var gallop_speed: float = 17.0
@export var acceleration: float = 6.5
@export var braking_force: float = 11.0
@export var turn_rate: float = 1.9
@export var turn_radius_at_speed: Curve

@export_group("Weight & Grip")
@export var gravity: float = 22.0
@export var lateral_damping: float = 8.0

@export_group("Stamina")
@export var max_stamina: float = 100.0
@export var stamina_drain_gallop: float = 12.0
@export var stamina_regen: float = 9.0

var current_speed: float = 0.0
var target_speed: float = 0.0
var stamina: float = 0.0
var gallop_pulse_timer: float = 0.0

func _ready() -> void:
	stamina = max_stamina
	stamina_changed.emit(stamina, max_stamina)

func _physics_process(delta: float) -> void:
	_handle_input(delta)
	_apply_weighted_motion(delta)
	_emit_feedback(delta)

func _handle_input(delta: float) -> void:
	var forward_input := Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	var turn_input := Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
	var is_accelerating := Input.is_action_pressed("accelerate")
	var braking := Input.is_action_pressed("brake")

	if forward_input > 0.1:
		target_speed = walk_speed
		if is_accelerating:
			target_speed = trot_speed
			if stamina > 0.0:
				target_speed = gallop_speed
				stamina = max(stamina - stamina_drain_gallop * delta, 0.0)
				stamina_changed.emit(stamina, max_stamina)
	else:
		target_speed = 0.0
		stamina = min(stamina + stamina_regen * delta, max_stamina)
		stamina_changed.emit(stamina, max_stamina)

	var accel := acceleration if target_speed > current_speed else braking_force
	if braking:
		target_speed = 0.0
		accel = braking_force * 1.3

	current_speed = move_toward(current_speed, target_speed, accel * delta)

	var normalized_speed := clamp(current_speed / gallop_speed, 0.0, 1.0)
	var radius_factor := 1.0
	if turn_radius_at_speed:
		radius_factor = turn_radius_at_speed.sample_baked(normalized_speed)
	rotation.y -= turn_input * turn_rate * radius_factor * delta

func _apply_weighted_motion(delta: float) -> void:
	var forward := -transform.basis.z
	var planar_velocity := forward * current_speed
	velocity.x = move_toward(velocity.x, planar_velocity.x, lateral_damping * delta)
	velocity.z = move_toward(velocity.z, planar_velocity.z, lateral_damping * delta)

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	move_and_slide()

func _emit_feedback(delta: float) -> void:
	speed_changed.emit(current_speed)
	if current_speed > trot_speed:
		gallop_pulse_timer += delta * remap(current_speed, trot_speed, gallop_speed, 1.6, 2.8)
		if gallop_pulse_timer >= 1.0:
			gallop_pulse_timer = 0.0
			gallop_beat.emit(clamp(current_speed / gallop_speed, 0.35, 1.0))
