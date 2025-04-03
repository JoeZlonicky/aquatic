class_name FreezeData
extends OnHitData


func apply(enemy: Enemy, _pod: Pod, _source_pos: Vector2) -> void:
	FreezeEffect.apply(enemy)
