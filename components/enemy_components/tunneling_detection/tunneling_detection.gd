extends Area2D


@export var enemy: Enemy
@onready var tunneling_particles: GPUParticles2D = $TunnelingParticles


func _ready() -> void:
	if has_overlapping_bodies():
		tunneling_particles.emitting = true
		hide_from_detection()
	else:
		tunneling_particles.emitting = false
		add_to_detection()


func _on_body_entered(_body: Node2D) -> void:
	if has_overlapping_bodies():
		tunneling_particles.emitting = true
		hide_from_detection()


func _on_body_exited(_body: Node2D) -> void:
	if not has_overlapping_bodies():
		tunneling_particles.emitting = false
		add_to_detection()


func hide_from_detection() -> void:
	enemy.collision_layer = 0


func add_to_detection() -> void:
	enemy.collision_layer = 64
