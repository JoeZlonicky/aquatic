@tool
class_name ExplosionGenerator
extends AbilityActive


@export var explosion_data: ExplosionData:
	set(value):
		explosion_data = value
		update_configuration_warnings()


func activate() -> void:
	activate_at(global_position)


func activate_at(pos: Vector2) -> void:
	Explosion.create(explosion_data, pod, pos)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := ConfigurationWarnings.any_properties_not_set(self, ["explosion_data"])
	var base_warnings := super._get_configuration_warnings()
	return warnings + base_warnings
