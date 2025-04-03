class_name PodShieldedModifier
extends PodModifier


func apply(pod: Pod) -> void:
	pod.shields += 1


func unapply(pod: Pod) -> void:
	pod.shields -= 1
