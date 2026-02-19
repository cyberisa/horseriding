extends GPUParticles3D
class_name DustEmitter

@export var horse_path: NodePath
@onready var horse: HorseController = get_node_or_null(horse_path)

func _process(_delta: float) -> void:
	if not horse:
		emitting = false
		return
	emitting = horse.is_on_floor() and horse.current_speed > 2.2
	amount_ratio = clamp(horse.current_speed / horse.gallop_speed, 0.2, 1.0)
