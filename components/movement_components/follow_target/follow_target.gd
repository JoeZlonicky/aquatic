@tool
class_name FollowTarget
extends Node


@export var node: Node2D:
	set(n):
		node = n
		update_configuration_warnings()
@export var target: Node2D

@export_range(0.0, 1000.0, 0.001, "or_greater", "suffix:px") var follow_distance: float = 100.0
@export_range(0.0, 2000.0, 0.001, "or_greater", "suffix:px/s") var max_move_speed: float = 2000.0
@export_range(0.0, 100.0, 0.001, "or_greater", "suffix:px") var distance_to_reach_max_move_speed: float = 50.0


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint() or not target or not is_far_enough_to_follow():
		return
	
	var to_target := target.global_position - node.global_position
	var dir := to_target.normalized()
	
	var desired_pos := target.global_position - dir * follow_distance
	var distance_from_desired_pos := (node.global_position - desired_pos).length()
	
	var move_speed_ratio := absf(distance_from_desired_pos) / distance_to_reach_max_move_speed
	move_speed_ratio = clampf(move_speed_ratio, 0.0, 1.0)
	
	var move_speed := lerpf(0.0, max_move_speed, move_speed_ratio)
	node.global_position = node.global_position.move_toward(desired_pos, move_speed * _delta)


func is_far_enough_to_follow() -> bool:
	return node.global_position.distance_to(target.global_position) > follow_distance


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ['node'])
