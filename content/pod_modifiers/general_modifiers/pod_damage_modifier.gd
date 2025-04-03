class_name PodDamageModifier
extends PodModifier


@export var modifier: int = 1


func apply(pod: Pod) -> void:
	var stats := pod.get_stats()
	stats.flat_damage_bonus += modifier


func unapply(pod: Pod) -> void:
	var stats := pod.get_stats()
	stats.flat_damage_bonus -= modifier
