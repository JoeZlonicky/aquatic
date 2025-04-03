class_name FreezeEffect
extends Node


const SCENE := preload("uid://eowyyxfktt2k")
const COLOR_MODULATE := Color("00457c")
const VULNERABILITY: float = 1.65

var _enemy: Enemy

@onready var thaw_timer: Timer = $ThawTimer


func _ready() -> void:
	assert(_enemy)
	_enemy.modulate = COLOR_MODULATE


static func apply(enemy: Enemy) -> void:
	if enemy.statuses.freeze:
		enemy.statuses.freeze.refresh()
		return
	
	var freeze := SCENE.instantiate() as FreezeEffect
	freeze._enemy = enemy
	enemy.statuses.freeze = freeze
	enemy.add_child(freeze)


func refresh() -> void:
	thaw_timer.start()


func end() -> void:
	_enemy.modulate = Color.WHITE
	_enemy.statuses.freeze = null
	queue_free()


func get_vulnerability() -> float:
	return VULNERABILITY


func _on_thaw_timer_timeout() -> void:
	end()
