extends Node
class_name GameManager

signal mission_started(name: String)
signal mission_completed(name: String, reward: int)
signal mission_failed(name: String)
signal progression_updated(money: int, reputation: int, upgrades: Dictionary)

@export var starting_money: int = 100
@export var starting_reputation: int = 0

var money: int
var reputation: int
var upgrades := {
	"stamina": 0,
	"speed": 0
}

func _ready() -> void:
	money = starting_money
	reputation = starting_reputation
	progression_updated.emit(money, reputation, upgrades)

func complete_mission(name: String, reward_money: int, reward_rep: int) -> void:
	money += reward_money
	reputation += reward_rep
	mission_completed.emit(name, reward_money)
	progression_updated.emit(money, reputation, upgrades)

func fail_mission(name: String) -> void:
	mission_failed.emit(name)

func buy_upgrade(upgrade_type: String, cost: int) -> bool:
	if money < cost:
		return false
	if not upgrades.has(upgrade_type):
		return false
	money -= cost
	upgrades[upgrade_type] += 1
	progression_updated.emit(money, reputation, upgrades)
	return true
