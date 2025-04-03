class_name ItemCost
extends Resource


@export var item: ItemData
@export_range(1, 999, 1) var quantity: int = 1


func can_afford(inventory: Inventory) -> bool:
	return inventory.get_item_count(item) >= quantity
