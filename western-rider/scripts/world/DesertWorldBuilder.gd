extends Node3D
class_name DesertWorldBuilder

@export var cactus_scene: PackedScene
@export var rock_scene: PackedScene
@export var dune_count: int = 120
@export var map_radius: float = 420.0
@export var seed_value: int = 7

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value

	_spawn_props(cactus_scene, int(dune_count * 0.5), rng)
	_spawn_props(rock_scene, dune_count, rng)

func _spawn_props(scene: PackedScene, count: int, rng: RandomNumberGenerator) -> void:
	if not scene:
		return
	for i in count:
		var prop := scene.instantiate() as Node3D
		var angle := rng.randf_range(0.0, TAU)
		var distance := rng.randf_range(25.0, map_radius)
		prop.position = Vector3(cos(angle) * distance, 0.0, sin(angle) * distance)
		prop.rotation.y = rng.randf_range(0.0, TAU)
		add_child(prop)
