class_name Explosion
extends Area2D


const SCENE := preload("uid://b1nbpd0openmg")

var _source_pod: Pod
var _data: ExplosionData
var _iteration: int = 0
var _damaged_bodies: Array[Node2D] = []


func _ready() -> void:
	collision_mask = PhysicsUtility.create_ability_collision_mask(
		false, _data.mining_power > 0, true)
	
	if _data.spawn_at_explosion:
		var spawn := _data.spawn_at_explosion.instantiate() as Node2D
		GameUtility.add_to_biome(spawn, global_position)
	
	var collision_shape := PhysicsUtility.create_circle_collision_shape(_data.collision_radius)
	add_child.call_deferred(collision_shape)
	
	get_tree().create_timer(_data.active_duration, false).timeout.connect(_on_active_duration_ended)
	
	# Errs on the side of excess time
	var free_time := 0.1 + _data.active_duration + _data.time_between_iterations
	if _iteration < _data.n_sub_iterations:
		free_time += _data.n_sub_explosions * _data.time_between_sub_explosions
	get_tree().create_timer(free_time, false).timeout.connect(queue_free)
	
	if _iteration >= _data.n_sub_iterations:
		return
	
	if _data.time_between_iterations:
		get_tree().create_timer(_data.time_between_iterations, false).timeout.connect(_trigger_sub_explosion)
	else:
		_trigger_sub_explosion()



static func create(data: ExplosionData, pod: Pod, pos: Vector2, iteration: int = 0) -> Explosion:
	var explosion := SCENE.instantiate() as Explosion
	explosion._data = data
	explosion._source_pod = pod
	explosion._iteration = iteration
	GameUtility.add_to_biome(explosion, pos)
	return explosion


func _trigger_sub_explosion() -> void:
	var n := _data.n_sub_explosions
	var angle := randf_range(0.0, TAU)
	var angle_between := TAU / n
	for i in n:
		var pos := global_position + Vector2.from_angle(angle) * _data.distance_per_sub_explosion
		create(_data, _source_pod, pos, _iteration + 1)
		angle += angle_between
		await get_tree().create_timer(_data.time_between_sub_explosions, false).timeout


func _on_active_duration_ended() -> void:
	monitoring = false


func _on_body_entered(body: Node2D) -> void:
	if _damaged_bodies.has(body):
		return
	
	var enemy := body as Enemy
	if enemy:
		for on_hit in _data.on_hit:
			on_hit.apply(enemy, _source_pod, global_position)
		for on_hit in _source_pod.on_hit_effects:
			on_hit.apply(enemy, _source_pod, global_position)
	
	var resource_pile := body as ResourcePile
	if resource_pile:
		resource_pile.try_to_mine(_data.mining_power)
	
	_damaged_bodies.push_back(enemy)
