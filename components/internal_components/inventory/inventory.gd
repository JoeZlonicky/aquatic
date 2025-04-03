class_name Inventory
extends RefCounted


signal item_added(item_data: ItemData, n: int)
signal item_removed(item_data: ItemData, n: int)
signal changed

var _items: Dictionary[ItemData, int] = {}


func add_item(item_data: ItemData, count: int = 1) -> void:
	assert(count >= 1)
	_items[item_data] = _items.get(item_data, 0) + count
	item_added.emit(item_data, count)
	changed.emit()


func remove_item(item_data: ItemData, count: int = 1) -> void:
	assert(count >= 1)
	
	var current_count: int = _items.get(item_data, 0)
	if current_count <= 0:
		return
	
	var new_count := current_count - count
	if new_count <= 0:
		_items.erase(item_data)
		item_removed.emit(item_data, current_count)
		return
	
	_items[item_data] = new_count
	item_removed.emit(item_data, current_count - new_count)
	changed.emit()


func get_items() -> Array:
	return _items.keys()


func get_item_count(item_data: ItemData) -> int:
	return _items.get(item_data, 0)


func empty() -> void:
	_items.clear()
