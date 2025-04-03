class_name PodCritChanceModifier
extends PodModifier


@export_range(0.0, 100.0, 0.001, "suffix:+%") var modifier: float = 1.0


func apply(pod: Pod) -> void:
	var stats := pod.get_stats()
	stats.crit_chance += modifier


func unapply(pod: Pod) -> void:
	var stats := pod.get_stats()
	stats.crit_chance -= modifier
