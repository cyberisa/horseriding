extends Node
class_name GallopAudioController

@export var horse_path: NodePath
@onready var horse: HorseController = get_node_or_null(horse_path)
@onready var hoof_player: AudioStreamPlayer3D = $HoofBeat

func _ready() -> void:
	if horse:
		horse.gallop_beat.connect(_on_gallop_beat)

func _on_gallop_beat(strength: float) -> void:
	hoof_player.pitch_scale = remap(strength, 0.35, 1.0, 0.9, 1.25)
	hoof_player.volume_db = remap(strength, 0.35, 1.0, -10.0, -2.5)
	hoof_player.play()
