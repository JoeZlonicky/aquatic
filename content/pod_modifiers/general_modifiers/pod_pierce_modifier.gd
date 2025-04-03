class_name PodPierceModifier
extends PodModifier


@export_range(0, 100, 1, "suffix:hits") var modifier: int = 1


func apply(pod: Pod) -> void:
	var stats := pod.get_stats()
	stats.pierce += modifier


func unapply(pod: Pod) -> void:
	var stats := pod.get_stats()
	stats.pierce -= modifier
