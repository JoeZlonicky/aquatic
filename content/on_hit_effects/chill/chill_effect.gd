class_name ChillEffect
extends Node


const SCENE := preload("uid://62pkutlrmlfm")

# x: Max health, y: chill stacks required to freeze
const MAX_HEALTH_TO_CHILL_STACKS_1 := Vector2i(30, 3)
const MAX_HEALTH_TO_CHILL_STACKS_2 := Vector2i(100, 10)

const HIGH_CHILL_THRESHOLD := 0.5
const HIGH_CHILL_DAMAGE_MODIFIER := 1.35
const LOW_CHILL_DAMAGE_MODIFIER := 1.15
const COLOR_MODULATE := Color("58cdfe")

const MOVE_SPEED_MODIFIER: float = 0.7

@export var _enemy: Enemy
@export var freeze: FreezeData

var _source_pod: Pod
var _stacks: int = 0
var _stacks_to_freeze: int = 0

@onready var _thaw_timer: Timer = $ThawTimer


func _ready() -> void:
	assert(_enemy)
	_update_stacks_to_freeze()
	_enemy.health.max_changed.connect(_on_enemy_max_health_changed)
	_check_for_freeze()


static func apply(enemy: Enemy, source_pod: Pod, stacks: int = 1) -> void:
	assert(stacks > 0)
	
	if enemy.statuses.freeze:
		enemy.statuses.freeze.refresh()
		return
	
	if enemy.statuses.chill:
		enemy.statuses.chill.add_more_stacks(stacks)
		return
	
	var chill := SCENE.instantiate() as ChillEffect
	chill._source_pod = source_pod
	chill._enemy = enemy
	chill._stacks = stacks
	enemy.statuses.chill = chill
	enemy.modulate = COLOR_MODULATE
	enemy.add_child(chill)


func add_more_stacks(n: int) -> void:
	assert(n > 0)
	_stacks += n
	_thaw_timer.start()
	_check_for_freeze()



func get_damage_modifier() -> float:
	var ratio: float = float(_stacks) / float(_stacks_to_freeze)
	if ratio >= HIGH_CHILL_THRESHOLD:
		return HIGH_CHILL_DAMAGE_MODIFIER
	
	return LOW_CHILL_DAMAGE_MODIFIER


func get_move_speed_modifier() -> float:
	return MOVE_SPEED_MODIFIER


func end() -> void:
	_enemy.statuses.chill = null
	if not _enemy.statuses.freeze:
		_enemy.modulate = Color.WHITE
	queue_free()


func _check_for_freeze() -> void:
	if _stacks < _stacks_to_freeze:
		return
	
	freeze.apply(_enemy, _source_pod, _source_pod.global_position)
	end()


func _update_stacks_to_freeze() -> void:
	var s := Vector2(MAX_HEALTH_TO_CHILL_STACKS_1.y, MAX_HEALTH_TO_CHILL_STACKS_2.y)
	var h := Vector2(MAX_HEALTH_TO_CHILL_STACKS_1.x, MAX_HEALTH_TO_CHILL_STACKS_2.x)
	var n := log(s.y / s.x) / log(h.y / h.x)
	var c := s.x / pow(h.x, n)
	
	var stacks := c * pow(float(_enemy.health.get_max()), n)
	_stacks_to_freeze = maxi(roundi(stacks), 1)


func _on_enemy_max_health_changed() -> void:
	_update_stacks_to_freeze()
	_check_for_freeze()


func _on_thaw_timer_timeout() -> void:
	_stacks = maxi(_stacks - 1, 0)
	if _stacks > 0:
		return
	
	end()
