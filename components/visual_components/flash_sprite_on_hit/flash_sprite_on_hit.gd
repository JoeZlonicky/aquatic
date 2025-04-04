@tool
extends Sprite2D


@export var _health: Health:
	set(value):
		_health = value
		update_configuration_warnings()

## Children nodes can be flashed as well if "Use Parent Material" is true
@export_color_no_alpha var color: Color = Color.WHITE
@export_range(0.1, 0.5, 0.001, "suffix:s") var duration: float = 0.2
@export_range(0.0, 1.0, 0.001) var peak_strength: float = 1.0
@export_range(0.0, 1.0, 0.001, "suffix:/1") var peak_moment: float = 0.25


var _tween: Tween = null


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_health.damaged.connect(_on_health_damaged)
	material.set("shader_parameter/flash_color", color)


func _on_health_damaged(_amount: int) -> void:
	if _tween and _tween.is_running():
		return
	
	_tween = create_tween()
	var time_to_peak := duration * peak_moment
	var time_from_peak := duration - time_to_peak
	
	_tween.tween_method(
		_update_flash_strength,
		0.0,
		peak_strength,
		time_to_peak).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_method(
		_update_flash_strength,
		peak_strength,
		0.0,
		time_from_peak).set_trans(Tween.TRANS_CUBIC)


func _update_flash_strength(strength: float) -> void:
	set_instance_shader_parameter("flash_strength", strength)


func _set(property: StringName, _value: Variant) -> bool:
	# Want to make sure texture is set, as it's the entire point of the node
	if property == "texture":
		# Deferred to check after it's set
		update_configuration_warnings.call_deferred()
	return false


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["_health", "texture"])
