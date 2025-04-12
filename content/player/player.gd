@tool
class_name Player
extends CharacterBody2D


@onready var notification_container: NotificationContainer = $NotificationContainer


func _ready() -> void:
	var inventory := GameUtility.get_inventory()
	inventory.item_added.connect(_on_inventory_item_added)
	inventory.item_removed.connect(_on_inventory_item_removed)
	
func _on_inventory_item_added(item_data: ItemData, count: int) -> void:
	notification_container.display_notification(item_data, count)


func _on_inventory_item_removed(item_data: ItemData, count: int) -> void:
	notification_container.display_notification(item_data, -count)
