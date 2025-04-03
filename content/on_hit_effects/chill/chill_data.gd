class_name ChillData
extends OnHitData


@export_range(1, 999, 1) var stacks: int = 1


func apply(enemy: Enemy, pod: Pod, _source_pos: Vector2) -> void:
	ChillEffect.apply(enemy, pod, stacks)
