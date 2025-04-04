@tool
extends Node


@export var _canvas_item: CanvasItem:
	set(value):
		_canvas_item = value
		update_configuration_warnings()

@export_range(0.1, 1.0, 0.001, "suffix:s") var _duration: float = 0.2


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	var tween := create_tween()
	tween.tween_property(_canvas_item, "modulate:a", 1.0, _duration).from(0.0)


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["_canvas_item"])
