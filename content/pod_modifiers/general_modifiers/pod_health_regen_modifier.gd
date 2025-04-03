class_name PodHealthRegenModifier
extends PodModifier


@export var amount: int = 10


func apply(pod: Pod) -> void:
	var health := pod.get_health()
	health.regen += amount


func unapply(pod: Pod) -> void:
	var health := pod.get_health()
	health.regen -= amount
