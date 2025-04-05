class_name Biome
extends Node2D


@export var bounds: ColorRect
@export var spawn_positions: Array[Node2D]


func get_spawn_position(i: int) -> Vector2:
	assert(i < spawn_positions.size())
	return spawn_positions[i].global_position
