@tool
extends Node2D


@export var _health: Health:
	set(value):
		_health = value
		update_configuration_warnings()
@export var item_data: ItemData:
	set(value):
		item_data = value
		update_configuration_warnings()

@export_range(1, 999) var quantity: int = 1


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_health.died.connect(_on_health_died)


func _on_health_died() -> void:
	for _i in quantity:
		ItemPickup.create.call_deferred(item_data, global_position)


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["_health", "item_data"])
