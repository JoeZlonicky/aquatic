class_name GameCamera
extends Camera2D
## Camera2D with additional utility


@export var _limit_padding: int = 0


func update_limits(bounds: Rect2) -> void:
	limit_left = int(bounds.position.x) + _limit_padding
	limit_right = int(bounds.position.x + bounds.size.x) - _limit_padding
	limit_top = int(bounds.position.y) + _limit_padding
	limit_bottom = int(bounds.position.y + bounds.size.y) - _limit_padding
