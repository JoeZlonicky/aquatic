class_name PodHealthModifier
extends PodModifier


@export var modifier: int = 10
@export var heal_to_full: bool = true


func apply(pod: Pod) -> void:
	var current := pod.get_health().get_max()
	pod.get_health().update_max_health(current + modifier, heal_to_full)


func unapply(pod: Pod) -> void:
	var current := pod.get_health().get_max()
	pod.get_health().update_max_health(current - modifier, heal_to_full)
