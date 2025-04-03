class_name PodOnHitModifier
extends PodModifier


@export var effect: OnHitData


func apply(pod: Pod) -> void:
	pod.on_hit_effects.append(effect)


func unapply(pod: Pod) -> void:
	pod.on_hit_effects.erase(effect)
