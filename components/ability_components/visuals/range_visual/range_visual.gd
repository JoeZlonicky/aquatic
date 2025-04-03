@tool
extends Node2D


const ARC_SEGMENTS: int = 32
const POINT_COUNT: int = 5
const LINE_WIDTH: int = 10

@export_range(0.0, 2000.0, 1.0, "suffix:px") var radius: float = 500.0:
	set(value):
		radius = value
		queue_redraw()
@export var outline_color: Color = Color("FFFFFF", 0.05):
	set(value):
		outline_color = value
		queue_redraw()
@export var background_color: Color = Color("FFFFFF", 0.025):
	set(value):
		background_color = value
		queue_redraw()
@export_range(-1.0, 1.0, 0.001, "suffix:rad/s") var rotation_speed: float = 0.1 
@export var visible_if_in_area: Area2D = null

var rotation_offset: float = 0.0


func _physics_process(delta: float) -> void:
	rotation_offset += rotation_speed * delta
	queue_redraw()


func _draw() -> void:
	if visible_if_in_area and not Engine.is_editor_hint():
		if not visible_if_in_area.monitoring or not visible_if_in_area.get_overlapping_bodies():
			return
	
	var angle_span := TAU / float(ARC_SEGMENTS) / 2.0
	for i in ARC_SEGMENTS:
		var start_angle := rotation_offset + angle_span * i * 2 - global_rotation
		var end_angle := start_angle + angle_span
		draw_arc(Vector2.ZERO, radius, start_angle, end_angle, POINT_COUNT,
			outline_color, LINE_WIDTH)
	
	draw_circle(Vector2.ZERO, radius, background_color, true)
