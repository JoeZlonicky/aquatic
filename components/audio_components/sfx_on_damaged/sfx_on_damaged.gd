@tool
extends AudioStreamPlayer2D


@export var _health: Health:
	set(h):
		_health = h
		update_configuration_warnings()


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_health.damaged.connect(_on_health_damaged)


func _on_health_damaged(_amount: int) -> void:
	playing = true


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["_health"])
