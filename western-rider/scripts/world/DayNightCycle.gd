extends DirectionalLight3D
class_name DayNightCycle

@export var day_length_seconds: float = 360.0
@export var horizon_color: Gradient
@export var world_environment_path: NodePath

var time_of_day: float = 0.25
@onready var world_environment: WorldEnvironment = get_node_or_null(world_environment_path)

func _process(delta: float) -> void:
	time_of_day = fmod(time_of_day + delta / day_length_seconds, 1.0)
	rotation.x = lerp(-PI * 0.1, PI * 1.2, time_of_day)

	if world_environment and horizon_color:
		var environment := world_environment.environment
		var sky_mat := environment.sky.sky_material
		if sky_mat is ProceduralSkyMaterial:
			sky_mat.sky_top_color = horizon_color.sample(time_of_day)

	light_energy = clamp(sin(time_of_day * TAU) * 1.2, 0.07, 1.0)
