class_name PlayerUtility


static func get_player() -> Player:
	var game_world := GameUtility.get_game_world()
	return game_world.player


static func get_inventory() -> Inventory:
	var game := GameUtility.get_game()
	return game.inventory
