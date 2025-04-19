class_name GameCamera
extends Camera2D
## [Camera2D] with additional utility.


## Update [Camera2D] limits to match the bounds of a [Rect2].
func update_limits(bounds: Rect2) -> void:
	limit_left = floori(bounds.position.x)
	limit_right = ceili(bounds.position.x + bounds.size.x)
	limit_top = floori(bounds.position.y)
	limit_bottom = ceili(bounds.position.y + bounds.size.y)
