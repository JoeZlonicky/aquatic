@tool
extends Node2D


@onready var capsule: PodCapsule = $Capsule
@onready var pod_destroyed_particles: GPUParticles2D = $PodDestroyedParticles
@onready var pod_health_bar: PodHealthBar = $PodHealthBar


func _ready() -> void:
	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_components_not_set([capsule, 
		pod_destroyed_particles, pod_health_bar])
