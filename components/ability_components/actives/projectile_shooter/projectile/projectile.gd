class_name Projectile
extends Area2D


signal hit(at: Vector2)

const SCENE := preload("uid://cn2tq66sfb302")
const NEAREST_IN_AREA_SCENE := preload("uid://cikuv1asqnpit")

var hits_left: int = 0

var _source_pod: Pod
var _data: ProjectileData
var _direction: Vector2 = Vector2.RIGHT
var _nearest_in_area: NearestInArea = null


func _ready() -> void:
	hits_left = 1 + _data.pierce + _source_pod.get_stats().pierce
	
	collision_mask = PhysicsUtility.create_ability_collision_mask(
		_data.hit_terrain, _data.hit_resource_piles, _data.hit_enemies)
	
	var collision_shape := PhysicsUtility.create_circle_collision_shape(_data.collision_radius)
	add_child(collision_shape)
	
	if _data.track_nearest_enemy:
		_add_tracking()


static func create(data: ProjectileData, pod: Pod, pos: Vector2, direction: Vector2) -> Projectile:
	var projectile := SCENE.instantiate() as Projectile
	projectile._data = data
	projectile._direction = direction.normalized()
	projectile._source_pod = pod
	GameUtility.add_to_biome(projectile, pos)
	return projectile


func _physics_process(delta: float) -> void:
	if _nearest_in_area and _nearest_in_area.get_nearest():
		var nearest_pos := _nearest_in_area.get_nearest().global_position
		var dir := global_position.direction_to(nearest_pos)
		_direction = MathUtility.rotate_towards_vector(_direction, dir, _data.track_rotate_speed)
		if _data.override_rotation_with_tracking:
			rotation = _direction.angle()
		
	position += _direction * _data.speed * delta
	rotation += _data.rotation_speed * delta


func _add_tracking() -> void:
	_nearest_in_area = NEAREST_IN_AREA_SCENE.instantiate()
	_nearest_in_area.collision_mask = PhysicsUtility.create_ability_collision_mask(false, false, true)
	add_child(_nearest_in_area)
	
	var shape := PhysicsUtility.create_circle_collision_shape(_data.tracking_radius)
	_nearest_in_area.add_child(shape)


func _on_body_entered(body: Node2D) -> void:
	var enemy := body as Enemy
	if enemy:
		for on_hit in _data.on_hit:
			on_hit.apply(enemy, _source_pod, global_position)
		for on_hit in _source_pod.on_hit_effects:
			on_hit.apply(enemy, _source_pod, global_position)
		hits_left -= 1
		if hits_left > 0:
			return
		
	var resource_pile := body as ResourcePile
	if resource_pile:
		resource_pile.try_to_mine(_data.mining_power)
		hits_left -= 1
		if hits_left > 0:
			return
	
	if _data.spawn_at_collision:
		var s := _data.spawn_at_collision.instantiate() as Node2D
		GameUtility.add_to_biome(s, global_position)
	
	hit.emit(global_position)
	queue_free()
