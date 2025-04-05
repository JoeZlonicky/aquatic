@tool
class_name Pod
extends CharacterBody2D


signal ability_triggered
signal buff_applied(buff: PodBuff)
signal destroyed
signal revived


const POD_BUFF_SCENE := preload("uid://cpqnncoharhyw")

@export var _health: Health:
	set(value):
		_health = value
		update_configuration_warnings()
@export var _stats: PodStats:
	set(value):
		_stats = value
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


func get_stats() -> PodStats:
	return _stats


func heal(amount: int) -> void:
	if not _health.is_alive():
		return
	
	_health.heal_damage(amount)


func damage(amount: int) -> void:
	_health.deal_damage(amount)


func apply_buff(buff_data: PodBuffData) -> PodBuff:
	var buff := POD_BUFF_SCENE.instantiate() as PodBuff
	buff.pod = self
	buff.data = buff_data
	add_child(buff)
	buff_applied.emit(buff)
	return buff


func emit_ability_triggered() -> void:
	# This is mainly done to stop a warning and also because it feels
	# wrong to emit another node's signals
	ability_triggered.emit()


func _on_health_died() -> void:
	destroyed.emit()


func _on_health_revived() -> void:
	revived.emit()


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["_health", "_stats"])
