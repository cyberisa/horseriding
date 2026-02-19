extends Node
class_name RaceMission

signal race_started
signal checkpoint_hit(index: int, total: int)
signal race_finished(time_seconds: float, reward: int)
signal race_failed

@export var checkpoints: Array[NodePath]
@export var race_time_limit: float = 110.0
@export var reward_money: int = 125
@export var reward_rep: int = 15
@export var horse_path: NodePath
@export var game_manager_path: NodePath

var horse: Node3D
var game_manager: GameManager
var race_active: bool = false
var checkpoint_index: int = 0
var time_left: float = 0.0

func _ready() -> void:
	horse = get_node_or_null(horse_path)
	game_manager = get_node_or_null(game_manager_path)
	_reset_checkpoints()

func _process(delta: float) -> void:
	if not race_active:
		if Input.is_action_just_pressed("interact"):
			start_race()
		return

	time_left -= delta
	if time_left <= 0.0:
		race_active = false
		race_failed.emit()
		if game_manager:
			game_manager.fail_mission("Dust Sprint")
		return

	_check_checkpoint_progress()

func start_race() -> void:
	race_active = true
	checkpoint_index = 0
	time_left = race_time_limit
	race_started.emit()
	_reset_checkpoints()

func _check_checkpoint_progress() -> void:
	if checkpoint_index >= checkpoints.size() or not horse:
		return
	var checkpoint := get_node_or_null(checkpoints[checkpoint_index]) as Node3D
	if not checkpoint:
		return
	if horse.global_position.distance_to(checkpoint.global_position) < 5.5:
		checkpoint_hit.emit(checkpoint_index + 1, checkpoints.size())
		checkpoint_index += 1
		if checkpoint_index >= checkpoints.size():
			_complete_race()

func _complete_race() -> void:
	race_active = false
	var completion_time := race_time_limit - time_left
	race_finished.emit(completion_time, reward_money)
	if game_manager:
		game_manager.complete_mission("Dust Sprint", reward_money, reward_rep)

func _reset_checkpoints() -> void:
	for cp_path in checkpoints:
		var cp := get_node_or_null(cp_path) as Node3D
		if cp:
			cp.visible = true
