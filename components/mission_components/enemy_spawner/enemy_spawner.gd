@tool
class_name EnemySpawner
extends Node


const ENEMY_SPAWN_DISTANCE: float = 4000.0
const CLUSTER_RADIUS: float = 300.0

@export var _enemies: Array[EnemyData] = []
@export_range(0.0, 1.0) var current_threat_level: float = 0.0
@export_range(1.0, 60.0, 1.0, "suffix:s") var _spawn_interval: float = 5.0
@export_range(1, 999, 1, "suffix:enemies") var _max_cluster_size: int = 10
@export var _autostart: bool = false

@export_category("Spawn Rate by Threat Level")
@export var _weevil_spawns_per_second: Curve
@export var _soldier_spawns_per_second: Curve
@export var _titan_spawns_per_second: Curve

var _interval_timer := Timer.new()
var _enemies_by_type: Dictionary[EnemyData.EnemyType, Array] = {}
var _spawn_progress: Dictionary[EnemyData.EnemyType, float] = {}
var _current_cluster_count: int = 0
var _current_cluster_position: Vector2


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for enemy_type: EnemyData.EnemyType in EnemyData.EnemyType.values():
		var enemies_of_type: Array[EnemyData] = []
		for enemy_data in _enemies:
			if enemy_data.type == enemy_type:
				enemies_of_type.append(enemy_data)
		_enemies_by_type[enemy_type] = enemies_of_type
	
	_interval_timer.wait_time = _spawn_interval
	_interval_timer.timeout.connect(_on_interval_timer_timeout)
	add_child(_interval_timer)
	
	if _autostart:
		_interval_timer.start()


func set_enabled(enabled: bool) -> void:
	if enabled and _interval_timer.is_stopped():
		_interval_timer.start()
	elif not enabled and not _interval_timer.is_stopped():
		_interval_timer.stop()


func _update_enemy_type_progress(enemy_type: EnemyData.EnemyType, spawn_rate: Curve) -> void:
	var current: float = _spawn_progress.get(enemy_type, 0.0)
	current += spawn_rate.sample(current_threat_level) * _spawn_interval
	
	while current >= 1.0:
		current -= 1.0
		_spawn_enemy_of_type(enemy_type)
		if _current_cluster_count > _max_cluster_size:
			_start_new_cluster()
	
	_spawn_progress[enemy_type] = current


func _spawn_enemy_of_type(enemy_type: EnemyData.EnemyType) -> void:
	var possible_enemies: Array[EnemyData] = _enemies_by_type.get(enemy_type, [])
	if not possible_enemies:
		return
	
	var enemy_data: EnemyData = possible_enemies.pick_random()
	_spawn_enemy(enemy_data)


func _spawn_enemy(enemy_data: EnemyData) -> void:
	var enemy := enemy_data.scene.instantiate() as Enemy
	var position := MathUtility.random_point_in_radius(_current_cluster_position,
		CLUSTER_RADIUS)
	GameUtility.add_to_biome(enemy, position)
	_current_cluster_count += 1


func _start_new_cluster() -> void:
	_current_cluster_count = 0
	var primary_pod := PlayerUtility.get_primary_pod()
	_current_cluster_position = MathUtility.random_point_on_radius(primary_pod.global_position,
		ENEMY_SPAWN_DISTANCE)
	

func _on_interval_timer_timeout() -> void:
	_start_new_cluster()
	if _weevil_spawns_per_second:
		_update_enemy_type_progress(EnemyData.EnemyType.WEEVIL, _weevil_spawns_per_second)
	if _soldier_spawns_per_second:
		_update_enemy_type_progress(EnemyData.EnemyType.SOLDIER, _soldier_spawns_per_second)
	if _titan_spawns_per_second:
		_update_enemy_type_progress(EnemyData.EnemyType.TITAN, _titan_spawns_per_second)
