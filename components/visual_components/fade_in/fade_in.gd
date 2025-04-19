extends Node


@export var _canvas_item: CanvasItem

@export_range(0.1, 1.0, 0.001, "suffix:s") var _duration: float = 0.2


func _ready() -> void:
	if not _canvas_item:
		push_warning(ConfigurationWarnings.missing_required_properties(self))
		return
	
	var tween := create_tween()
	tween.tween_property(_canvas_item, "modulate:a", 1.0, _duration).from(0.0)
