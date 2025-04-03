class_name NearestInArea
extends Area2D


signal new_nearest(node: Node2D)
signal no_nearest

@export_flags_2d_physics var line_of_sight_blockers: int

var _nearest: Node2D = null
var _is_updated: bool = false


func _physics_process(_delta: float) -> void:
	_is_updated = false


func get_nearest() -> Node2D:
	if not _is_updated:
		_update_nearest()
	return _nearest


func _update_nearest() -> void:
	_nearest = null
	
	var overlapping := get_overlapping_bodies() + get_overlapping_areas()
	var nearest_distance_squared := INF
	var nearest_so_far: Node2D = null
	for node: Node2D in overlapping:
		var pos := node.global_position
		var distance_squared := pos.distance_squared_to(global_position)
		if nearest_so_far and distance_squared > nearest_distance_squared:
			continue
		
		if line_of_sight_blockers and not _is_in_line_of_sight(pos):
			continue
		
		nearest_so_far = node
		nearest_distance_squared = distance_squared
	
	_set_nearest(nearest_so_far)


func _set_nearest(node: Node2D) -> void:
	if _nearest == node:
		_is_updated = true
		return
	
	_nearest = node
	_is_updated = true
	
	if _nearest == null:
		no_nearest.emit()
		return
	
	new_nearest.emit(_nearest)


func _is_in_line_of_sight(to: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(global_position, to, 
		line_of_sight_blockers, [self])
	var result := space_state.intersect_ray(query)
	return result.is_empty()


func _on_area_entered(_area: Area2D) -> void:
	_is_updated = false


func _on_body_entered(_body: Node2D) -> void:
	_is_updated = false


func _on_area_exited(_area: Area2D) -> void:
	_is_updated = false


func _on_body_exited(_body: Node2D) -> void:
	_is_updated = false
