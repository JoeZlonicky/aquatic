@tool
extends AbilityActive


@export_range(10.0, 2000.0, 1.0, "suffix:px") var _radius: float = 100.0:
	set(value):
		_radius = value
		queue_redraw()
@export var on_hit: Array[OnHitData] = []
@export var activate_on_ready: bool = false
@export var spawn_on_enemy: PackedScene = null

@onready var _area_2d: Area2D = $Area2D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	var collision_shape := PhysicsUtility.create_circle_collision_shape(_radius)
	_area_2d.add_child(collision_shape)
	
	pod.destroyed.connect(_on_pod_destroyed)
	
	if not activate_on_ready:
		return
	
	activate.call_deferred()


func activate() -> void:
	_area_2d.monitoring = true


func end() -> void:
	_area_2d.monitoring = false


func _on_area_2d_body_entered(enemy: Enemy) -> void:
	if not enemy:
		return
	
	for data in on_hit:
		data.apply(enemy, pod, global_position)
	for data in pod.on_hit_effects:
		data.apply(enemy, pod, global_position)
	
	if spawn_on_enemy:
		var spawn := spawn_on_enemy.instantiate() as Node2D
		GameUtility.add_to_biome(spawn, enemy.global_position)


func _on_pod_destroyed() -> void:
	end()


func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	
	draw_circle(Vector2.ZERO, _radius, Color.WHITE, false)
