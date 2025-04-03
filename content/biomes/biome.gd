class_name Biome
extends Node2D


@export var bounds: ColorRect
@export var spawn_positions: Array[Node2D]

var enemy_container: Node2D = null


func get_spawn_position(i: int) -> Vector2:
	assert(i < spawn_positions.size())
	return spawn_positions[i].global_position


func add_enemy(enemy: Enemy) -> void:
	if not enemy_container:
		enemy_container = Node2D.new()
		enemy_container.z_index = -1
		add_child(enemy_container)
	
	enemy_container.add_child(enemy)


func kill_all_enemies() -> void:
	if not enemy_container:
		return
	
	for child in enemy_container.get_children():
		var enemy := child as Enemy
		if not enemy:
			continue
		enemy.health.kill()
