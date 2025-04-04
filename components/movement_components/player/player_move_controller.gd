@tool
class_name PlayerMoveController
extends Node


@export var pod: Pod:
	set(value):
		pod = value
		update_configuration_warnings()
@export var pod_capsule: PodCapsule
@export var emit_particles_while_moving: GPUParticles2D

@export_range(1.0, 2000.0, 0.001, "or_greater", "suffix:px/s²") var acceleration: float = 1000.0
@export_range(1.0, 2000.0, 0.001, "or_greater", "suffix:px/s²") var decceleration: float = 1200.0
@export_range(1.0, 1000.0, 0.001, "or_greater", "suffix:px/s") var max_speed: float = 550.0

var last_nonzero_move_input: Vector2 = Vector2.RIGHT
var auto_move: bool = false


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var move_input := InputUtility.get_move_vector()
	
	pod_capsule.update_look_direction(move_input, delta)
	if emit_particles_while_moving:
		emit_particles_while_moving.emitting = move_input != Vector2.ZERO
	
	if move_input:
		last_nonzero_move_input = move_input.normalized()
	
	var goal_velocity := move_input * max_speed
	if auto_move:
		goal_velocity = last_nonzero_move_input * max_speed
	
	var current_speed := pod.velocity.length()
	if current_speed <= max_speed:
		pod.velocity = pod.velocity.move_toward(goal_velocity, acceleration * delta)
	else:
		pod.velocity = pod.velocity.move_toward(goal_velocity, decceleration * delta)
	pod.move_and_slide()


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ['pod', 'pod_capsule'])
