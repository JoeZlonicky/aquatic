class_name Passage
extends Area2D


enum PassageTo {
	INNER_REEF,
	REEF,
	MUSHROOM_REEF
}

@export var passage_to: PassageTo
@export var spawn_pos_index: int = 0


func _on_body_entered(player: Player) -> void:
	if not player:
		return
	
	await get_tree().process_frame
	
	var world := GameUtility.get_game_world()
	
	var data: BiomeData = null
	match passage_to:
		PassageTo.INNER_REEF:
			data = load("uid://bsbh3wtb4m8dr")
		PassageTo.REEF:
			data = load("uid://dcgpipiva54lm")
		PassageTo.MUSHROOM_REEF:
			data = load("uid://bac7ard2csc7")
	
	world.change_biome(data, spawn_pos_index)
