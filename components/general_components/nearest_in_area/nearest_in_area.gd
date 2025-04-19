class_name NearestInArea
extends Area2D
## Calculates and caches what [CollisionObject2D] is the closest.


## If set, the closest must pass a raycast check.
@export_flags_2d_physics var line_of_sight_blockers: int

var _nearest: CollisionObject2D = null
var _is_updated: bool = false


func _physics_process(_delta: float) -> void:
	_is_updated = false


## Gets the nearest [CollisionObject2D].
func get_nearest() -> CollisionObject2D:
	if not _is_updated:
		_update_nearest()
	return _nearest


func _update_nearest() -> void:
	_nearest = null
	
	var overlapping := get_overlapping_bodies() + get_overlapping_areas()
	var nearest_distance_squared := INF
	for node: CollisionObject2D in overlapping:
		var pos := node.global_position
		var distance_squared := pos.distance_squared_to(global_position)
		if _nearest and distance_squared > nearest_distance_squared:
			continue
		
		if not _is_in_line_of_sight(pos):
			continue
		
		_nearest = node
		nearest_distance_squared = distance_squared
	
	_is_updated = true


func _is_in_line_of_sight(to: Vector2) -> bool:
	if not line_of_sight_blockers:
		return true
	
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(global_position, to, 
		line_of_sight_blockers, [self])
	var result := space_state.intersect_ray(query)
	return result.is_empty()


func _on_area_entered(_area: Area2D) -> void:
	_is_updated = false


func _on_body_entered(_body: PhysicsBody2D) -> void:
	_is_updated = false


func _on_area_exited(_area: Area2D) -> void:
	_is_updated = false


func _on_body_exited(_body: PhysicsBody2D) -> void:
	_is_updated = false
