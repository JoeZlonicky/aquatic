@tool
class_name WaterShader
extends ColorRect


@export var bounds: ColorRect


func _ready() -> void:
	if not bounds:
		push_warning(ConfigurationWarnings.missing_required_properties(self))
		return
	
	size = bounds.size
	position = bounds.position
