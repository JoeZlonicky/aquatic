@tool
class_name PodHealthBar
extends TextureRect


@export var _pod: Pod:
	set(value):
		_pod = value
		update_configuration_warnings()
@export_color_no_alpha var _color: Color = Color.WHITE:
	set(value):
		_color = value
		_update_filled_color()


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_update_fill()
	_pod.get_health().damaged.connect(_on_pod_health_damaged)
	_pod.get_health().healed.connect(_on_pod_health_healed)


func _update_fill() -> void:
	var ratio := _pod.get_health().get_ratio()
	set_instance_shader_parameter("fill_ratio", ratio)


func _update_filled_color() -> void:
	set_instance_shader_parameter("filled_color", _color)


func _on_pod_health_damaged(_amount: int) -> void:
	_update_fill()


func _on_pod_health_healed(_amount: int) -> void:
	_update_fill()


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["_pod"])
