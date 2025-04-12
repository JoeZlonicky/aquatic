class_name ItemPickup
extends Sprite2D


const SCENE := preload("uid://di6br3x7ub1t2")
const Z_INDEX_AFTER_PICKUP: int = -1

@export_range(0.0, 10.0, 0.001, "suffix:rad/s") var rotation_speed: float = 3.0
@export_range(1.0, 2000.0, 0.001, "suffix:px/s²") var acceleration: float = 1500.0
@export_range(0.0, 2000.0, 0.001, "suffix:px/s²") var correction_acceleration: float = 2000.0
@export_range(1.0, 2000.0, 0.001, "suffix:px/s") var max_speed: float = 1500.0

@export_range(0.0, 2000.0, 0.001, "suffix:px/s") var random_start_speed: float = 600.0
@export_range(0.0, 2000.0, 0.001, "suffix:px/s²") var start_deceleration: float = 1500.0
@export var collect_distance: float = 70.0

var _item_data: ItemData
var _target: Node2D
var _velocity := Vector2.ZERO

@onready var trail_particles: GPUParticles2D = $TrailParticles
@onready var glow: Sprite2D = $Glow
@onready var fade_player: AnimationPlayer = $FadePlayer


static func create(item_data: ItemData, pos: Vector2) -> ItemPickup:
	var pickup := SCENE.instantiate() as ItemPickup
	pickup._item_data = item_data
	GameUtility.add_to_biome(pickup, pos)
	return pickup


func _ready() -> void:
	var dir := MathUtility.random_direction()
	_velocity += dir * random_start_speed
	texture = _item_data.texture
	self_modulate = _item_data.modulate
	glow.self_modulate = _item_data.modulate
	trail_particles.hide()


func _physics_process(delta: float) -> void:
	if not _target:
		position += _velocity * delta
		_velocity = _velocity.move_toward(Vector2.ZERO, 1500.0 * delta)
		return
	
	var to_target := global_position.direction_to(_target.global_position)
	_velocity += to_target * acceleration * delta
	
	var correction := to_target - _velocity.normalized()
	_velocity += correction * correction_acceleration * delta
	
	_velocity = _velocity.limit_length(max_speed)
	position += _velocity * delta
	rotation += rotation_speed * delta
	
	if global_position.distance_to(_target.global_position) < collect_distance:
		collect()


func collect() -> void:
	var inventory := PlayerUtility.get_inventory()
	inventory.add_item(_item_data)
	
	GameUtility.one_shot_and_reparent_particles(trail_particles)
	queue_free()


func _on_pickup_radius_body_entered(_body: Node2D) -> void:
	if _target:
		return
	
	_target = PlayerUtility.get_player()
	z_index = Z_INDEX_AFTER_PICKUP
	trail_particles.show()
	fade_player.play("fade_out")
