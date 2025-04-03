class_name PlayerUtility


static func get_primary_pod() -> Pod:
	var train := get_player_train()
	return train.get_primary_pod()


static func get_pod_setup() -> Array[PodData]:
	var game := GameUtility.get_game()
	return game.pod_setup


static func get_player_train() -> PodTrain:
	var world := GameUtility.get_game_world()
	return world.player_train


static func get_inventory() -> Inventory:
	var game := GameUtility.get_game()
	return game.inventory
