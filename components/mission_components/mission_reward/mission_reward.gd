class_name MissionReward
extends Node2D


@export var item_data: ItemData
@export var quantity: int = 1


func grant_reward() -> void:
	if not item_data:
		return
	
	for _i in quantity:
		ItemPickup.create(item_data, global_position)
