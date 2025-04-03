class_name KnockbackEffect
extends Node


const SCENE := preload("uid://dwhgn6yqcc0w8")

const KNOCKBACK_SPEED: float = 1000.0
const KNOCKBACK_ROTATION_SPEED: float = 10.0

@export var _enemy: Enemy

var displacement := Vector2.ZERO


static func apply(enemy: Enemy, source_pos: Vector2, distance: float = 0.0) -> void:
	assert(distance >= 0.0)
	if enemy.statuses.freeze:
		enemy.health.kill()
		return
	
	var dir := source_pos.direction_to(enemy.global_position)
	if enemy.statuses.knockback:
		enemy.statuses.knockback.displacement += dir * distance
		return
	
	var knockback := SCENE.instantiate() as KnockbackEffect
	knockback._enemy = enemy
	knockback.displacement = dir * distance
	enemy.statuses.knockback = knockback
	enemy.add_child(knockback)


func _physics_process(delta: float) -> void:
	_enemy.rotation += KNOCKBACK_ROTATION_SPEED * delta
	
	_enemy.velocity = displacement.normalized() * KNOCKBACK_SPEED
	_enemy.move_and_slide()
	
	displacement = displacement.move_toward(Vector2.ZERO, KNOCKBACK_SPEED * delta)
	
	if not displacement:
		end()


func end() -> void:
	_enemy.statuses.knockback = null
	queue_free()
