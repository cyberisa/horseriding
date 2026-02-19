extends CanvasLayer
class_name HUDController

@export var horse_path: NodePath
@export var game_manager_path: NodePath
@export var race_mission_path: NodePath

@onready var speed_label: Label = %SpeedLabel
@onready var stamina_bar: TextureProgressBar = %StaminaBar
@onready var objective_label: Label = %ObjectiveLabel
@onready var progression_label: Label = %ProgressionLabel

func _ready() -> void:
	var horse := get_node_or_null(horse_path) as HorseController
	if horse:
		horse.speed_changed.connect(_on_speed_changed)
		horse.stamina_changed.connect(_on_stamina_changed)

	var game_manager := get_node_or_null(game_manager_path) as GameManager
	if game_manager:
		game_manager.progression_updated.connect(_on_progression_updated)

	var race := get_node_or_null(race_mission_path) as RaceMission
	if race:
		race.race_started.connect(func() -> void: objective_label.text = "Race Active: Reach all checkpoints!")
		race.race_finished.connect(func(time_sec: float, _reward: int) -> void: objective_label.text = "Race Won in %.1fs" % time_sec)
		race.race_failed.connect(func() -> void: objective_label.text = "Race Failed: Time ran out")

func _on_speed_changed(speed: float) -> void:
	speed_label.text = "Speed: %d km/h" % int(speed * 4.2)

func _on_stamina_changed(current: float, max_value: float) -> void:
	stamina_bar.max_value = max_value
	stamina_bar.value = current

func _on_progression_updated(money: int, reputation: int, upgrades: Dictionary) -> void:
	progression_label.text = "$%d | REP %d | SPD %d | STA %d" % [
		money,
		reputation,
		upgrades.get("speed", 0),
		upgrades.get("stamina", 0)
	]
