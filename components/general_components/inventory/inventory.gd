class_name Inventory
extends RefCounted


signal item_added(item_data: ItemData, n: int)
signal item_removed(item_data: ItemData, n: int)
signal changed

var _items: Dictionary[ItemData, int] = {}


## Add a given number of [ItemData].
func add_item(item_data: ItemData, count: int = 1) -> void:
	assert(count >= 1)
	_items[item_data] = _items.get(item_data, 0) + count
	item_added.emit(item_data, count)
	changed.emit()


## Removes up to a given number of [ItemData].
func remove_item(item_data: ItemData, count: int = 1) -> void:
	assert(count >= 1)
	
	var current_count: int = _items.get(item_data, 0)
	if current_count <= 0:
		return
	
	var new_count := current_count - count
	if new_count <= 0:
		_items.erase(item_data)
	else:
		_items[item_data] = new_count
	item_removed.emit(item_data, current_count - new_count)
	changed.emit()


## Gets all [ItemData] that are contained.
func get_items() -> Array:
	return _items.keys()


## Returns the quantity of an item (0 if there are none).
func get_item_count(item_data: ItemData) -> int:
	return _items.get(item_data, 0)


## Removes all items.
func empty() -> void:
	_items.clear()
