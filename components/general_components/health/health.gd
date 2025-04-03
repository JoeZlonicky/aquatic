class_name Health
extends Node


signal died
signal revived
signal damaged(amount: int)
signal healed(amount: int)
signal max_changed

@export_range(1, 100, 1, "or_greater") var _max: int = 10
@export_range(0, 100, 1, "or_greater") var regen: int = 0
@export var regen_while_dead: bool = false

@onready var _current: int = _max


func get_current() -> int:
	return _current


func get_max() -> int:
	return _max


func get_ratio(clamp_value: bool = false) -> float:
	var ratio := float(_current) / float(_max)
	if clamp_value:
		return clampf(ratio, 0.0, 1.0)
	return ratio


func deal_damage(amount: int) -> void:
	assert(amount >= 0)
	
	if _current <= 0 || amount == 0:
		return
	
	var before := _current
	_current = maxi(_current - amount, 0)
	damaged.emit(before - _current)
	
	if _current == 0:
		died.emit()


func heal_damage(amount: int) -> void:
	assert(amount >= 0)
	
	if _current == _max or amount == 0:
		return
	
	var before := _current
	_current = mini(_current + amount, _max)
	healed.emit(_current - before)


func heal_to_full() -> void:
	heal_damage(_max - _current)


func is_alive() -> bool:
	return _current > 0


func revive(to_full: bool) -> void:
	assert(_current == 0)
	if to_full:
		heal_to_full()
		return
		
	heal_damage(1)
	revived.emit()


func kill() -> void:
	deal_damage(_current)


func update_max_health(new_value: int, restore_to_full: bool = true) -> void:
	var changed: bool = new_value != _max
	_max = new_value
	if _current > _max or restore_to_full:
		_current = _max
	if changed:
		max_changed.emit()


func _on_regen_timer_timeout() -> void:
	if not regen or (not is_alive() and not regen_while_dead):
		return
	
	heal_damage(regen)
