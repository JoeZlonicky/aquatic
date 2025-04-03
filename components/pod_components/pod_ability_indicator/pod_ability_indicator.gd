@tool
class_name PodAbilityIndicator
extends TextureRect


@onready var circle: TextureRect = $Circle


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	set_fill(0.0)


func set_fill_color(color: Color) -> void:
	circle.set_instance_shader_parameter("filled_color", color)
	modulate = color


# ratio will be clamped
func set_fill(ratio: float) -> void:
	ratio = clampf(ratio, 0.0, 1.0)
	circle.set_instance_shader_parameter("fill_ratio", ratio)
