class_name KnockbackData
extends OnHitData


@export_range(0.0, 1000.0, 0.001, "or_greater", "suffix:px") var distance: float = 100.0


func apply(enemy: Enemy, _pod: Pod, source_pos: Vector2) -> void:
	KnockbackEffect.apply(enemy, source_pos, distance)
