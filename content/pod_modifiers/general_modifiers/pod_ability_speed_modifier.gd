class_name PodAbilitySpeedModifier
extends PodModifier


@export_range(0.0, 100.0, 0.001) var modifier: float = 1.0


func apply(pod: Pod) -> void:
	var stats := pod.get_stats()
	stats.ability_speed_modifier += modifier


func unapply(pod: Pod) -> void:
	var stats := pod.get_stats()
	stats.ability_speed_modifier -= modifier
