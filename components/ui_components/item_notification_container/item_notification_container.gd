class_name NotificationContainer
extends VBoxContainer


const PICKUP_NOTIFICATION_SCENE := preload("uid://b3q5b7hm5t5t4")

var notifications: Dictionary[ItemData, ItemPickupNotification] = {}


func display_notification(item_data: ItemData, n: int = 1) -> void:
	var notif: ItemPickupNotification = notifications.get(item_data, null)
	if notif == null:
		notif = PICKUP_NOTIFICATION_SCENE.instantiate()
		add_child(notif)
		
		notif.display(item_data, n)
		notifications[item_data] = notif
		
		notif.tree_exited.connect(_on_notification_tree_exited.bind(item_data))
	else:
		notif.add_to_displayed(n)


func _on_notification_tree_exited(item_data: ItemData) -> void:
	notifications.erase(item_data)
