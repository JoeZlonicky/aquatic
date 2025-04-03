@tool
class_name WaterShader
extends ColorRect


@export_category("Required")
@export var bounds: ColorRect


func _ready() -> void:
	if not bounds:
		return
	
	size = bounds.size
	position = bounds.position


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["bounds"])
