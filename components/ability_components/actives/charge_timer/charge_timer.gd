@tool
class_name ChargeTimer
extends AbilityActive


const CHARGE_PARTICLES_SCENE := preload("uid://duodgy313wnli")

@export_range(0.1, 10.0, 0.001, "suffix:s") var amount: float = 1.0
@export_category("One Required")
@export var ability_timer: AbilityTimer
@export var duration_timer: AbilityDurationTimer


func activate() -> void:
	if ability_timer:
		ability_timer.timer += amount * ability_timer.calc_speed_modifier()
	if duration_timer and not duration_timer.is_duration_active:
		duration_timer.timer += amount * duration_timer.calc_speed_modifier()
	
	# Particles will handle their own emission and clean up
	var particles := CHARGE_PARTICLES_SCENE.instantiate() as GPUParticles2D
	add_child(particles)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := ConfigurationWarnings.at_least_one_property_set(self,
		["ability_timer", "duration_timer"])
	var base_warnings := super._get_configuration_warnings()
	return warnings + base_warnings
