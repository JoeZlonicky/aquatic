class_name AttackPlayerArea
extends Area2D


@export_range(1, 100, 1, "or_greater") var base_damage: int = 10
@export var statuses: Statuses


func _on_body_entered(pod: Pod) -> void:
	var modifier := statuses.get_damage_modifier()
	var damage := roundi(float(base_damage) * modifier)
	pod.damage(damage)
