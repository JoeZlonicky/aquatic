class_name DropItemsOnDeath
extends Node2D
## Creates [ItemPickup] drops when [Health] dies.


@export var _health: Health
@export var _item_data: ItemData
@export_range(1, 999) var quantity: int = 1


func _ready() -> void:
	if not _health or not _item_data:
		push_warning(ConfigurationWarnings.missing_required_properties(self, owner))
		return
	
	_health.died.connect(_on_health_died)


func _on_health_died() -> void:
	for _i in quantity:
		ItemPickup.create.call_deferred(_item_data, global_position)
