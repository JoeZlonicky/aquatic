class_name PodStats
extends Node


@export_range(0.0, 1000.0, 0.001) var ability_speed_modifier: float = 0.0
@export_range(0.0, 100.0, 0.001, "suffix:%") var crit_chance: float = 0.0
@export_range(1.0, 10.0, 0.001, "suffix:x") var crit_muliplier: float = 1.5
@export_range(0, 100) var flat_damage_bonus: int = 0
@export_range(0, 100, 1, "suffix:hits") var pierce: int = 0


func calc_modified_cooldown(base_cooldown: float) -> float:
	var k: float = 0.03
	var lower_limit: float = 0.15
	base_cooldown = maxf(base_cooldown, lower_limit)
	
	var cooldown := (base_cooldown - lower_limit) / (1.0 + k * ability_speed_modifier)
	cooldown += lower_limit
	return cooldown
