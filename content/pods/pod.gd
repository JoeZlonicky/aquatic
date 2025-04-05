@tool
class_name Pod
extends CharacterBody2D


signal destroyed
signal revived

@export var _health: Health:
	set(value):
		_health = value
		update_configuration_warnings()

var train: PodTrain = null
var train_index: int = 0


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_health.died.connect(_on_health_died)
	_health.revived.connect(_on_health_revived)


func get_health() -> Health:
	return _health


func heal(amount: int) -> void:
	if not _health.is_alive():
		return
	
	_health.heal_damage(amount)


func damage(amount: int) -> void:
	_health.deal_damage(amount)


func _on_health_died() -> void:
	destroyed.emit()


func _on_health_revived() -> void:
	revived.emit()


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["_health"])
