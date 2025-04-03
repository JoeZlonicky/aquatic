@tool
class_name AbilityActive
extends Node2D


@export var pod: Pod:
	set(value):
		pod = value
		update_configuration_warnings()


func activate() -> void:
	pass


# Only used by some abilities (e.g. buff)
func end() -> void:
	pass


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["pod"])
