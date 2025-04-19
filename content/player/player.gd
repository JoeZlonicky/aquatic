class_name Player
extends CharacterBody2D


@onready var notification_container: NotificationContainer = $NotificationContainer
@onready var capsule: PlayerCapsule = $Capsule


func _ready() -> void:
	var inventory := GameUtility.get_inventory()
	inventory.item_added.connect(_on_inventory_item_added)
	inventory.item_removed.connect(_on_inventory_item_removed)


func _physics_process(delta: float) -> void:
	var look_direction := InputUtility.get_move_vector()
	capsule.update_look_direction(look_direction, delta)


func _on_inventory_item_added(item_data: ItemData, count: int) -> void:
	notification_container.display_notification(item_data, count)


func _on_inventory_item_removed(item_data: ItemData, count: int) -> void:
	notification_container.display_notification(item_data, -count)
