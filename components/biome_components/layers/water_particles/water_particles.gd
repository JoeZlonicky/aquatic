@tool
class_name WaterParticles
extends Node2D


@export_category("Required")
@export var bounds: ColorRect

@export_category("Config")
@export var relative_area := Vector2i(1920, 1080)
@export_range(0, 100, 1, "suffix:particles/area") var background_density: int = 20
@export_range(0, 1000, 1, "suffix:particles/area") var foreground_density: int = 250

@onready var background_particles: GPUParticles2D = $BackgroundParticles
@onready var foreground_particles: GPUParticles2D = $ForegroundParticles


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	position = bounds.position
	_update_particles(background_particles, background_density)
	_update_particles(foreground_particles, foreground_density)
	
	foreground_particles.show()



func _update_particles(particles: GPUParticles2D, relative_particle_count: int) -> void:
	var area := bounds.size.x * bounds.size.y
	var ratio := float(area) / float(relative_area.x * relative_area.y)
	
	particles.amount = roundi(ratio * relative_particle_count)
	particles.visibility_rect = Rect2(-bounds.size / 2.0, bounds.size)
	particles.position = bounds.size / 2.0
	
	var process_material: ParticleProcessMaterial = particles.process_material 
	process_material.emission_box_extents.x = bounds.size.x / 2.0
	process_material.emission_box_extents.y = bounds.size.y / 2.0


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["bounds"])
