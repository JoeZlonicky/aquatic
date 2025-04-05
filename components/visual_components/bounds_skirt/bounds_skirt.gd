class_name BoundsSkirt
extends Node2D
## Intended to provide a color skirt (e.g. black) outside of camera bounds

@export_range(0, 99999, 1, "suffix:px") var _vertical_skirt: int = 0
@export_range(0, 99999, 1, "suffix:px") var _horizontal_skirt: int = 0
@export_color_no_alpha var _color: Color = Color.BLACK

var _left_cover := ColorRect.new()
var _right_cover := ColorRect.new()
var _top_cover := ColorRect.new()
var _bottom_cover := ColorRect.new()


func _ready() -> void:
	for cover: ColorRect in [_left_cover, _right_cover, _top_cover, _bottom_cover]:
		cover.color = _color
		add_child(cover)


func update_bounds(global_bounds: Rect2) -> void:
	var bounds_x := global_bounds.position.x
	var bounds_y := global_bounds.position.y
	var bounds_width := global_bounds.size.x
	var bounds_height := global_bounds.size.y
	var bounds_right := bounds_x + bounds_width
	var bounds_bottom := bounds_y + bounds_height
	
	var skirt_width := bounds_width + 2 * _horizontal_skirt
	var skirt_height := bounds_height + 2 * _vertical_skirt
	var skirt_topleft := Vector2(bounds_x - _horizontal_skirt, bounds_y - _vertical_skirt)
	
	_left_cover.size = Vector2(_horizontal_skirt, skirt_height)
	_left_cover.global_position = skirt_topleft
	
	_right_cover.size = _left_cover.size
	_right_cover.global_position = Vector2(bounds_right, skirt_topleft.y)
	
	_top_cover.size = Vector2(skirt_width, _vertical_skirt)
	_top_cover.global_position = skirt_topleft
	
	_bottom_cover.size = _top_cover.size
	_bottom_cover.global_position = Vector2(skirt_topleft.x, bounds_bottom)
