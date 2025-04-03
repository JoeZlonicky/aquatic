class_name Statuses
extends Node


var chill: ChillEffect = null
var freeze: FreezeEffect = null
var knockback: KnockbackEffect = null


func can_move() -> bool:
	return not (freeze or knockback)


func get_damage_modifier() -> float:
	var modifier: float = 1.0
	if chill:
		modifier *= chill.get_damage_modifier()
	return modifier


func get_move_speed_modifier() -> float:
	var modifier: float = 1.0
	if chill:
		modifier *= chill.get_move_speed_modifier()
	return modifier


func get_vulnerability() -> float:
	var modifier: float = 1.0
	if freeze:
		modifier *= freeze.get_vulnerability()
	return modifier
