@tool
extends Node


@export var _particles: GPUParticles2D:
	set(p):
		_particles = p
		update_configuration_warnings()
@export var _emit_on_ready: bool = false


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_particles.finished.connect(_on_particles_finished)
	
	if not _emit_on_ready:
		return
	_particles.emitting = true


func _on_particles_finished() -> void:
	_particles.queue_free()


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["_particles"])
