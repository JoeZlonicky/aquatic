class_name ProjectileData
extends Resource


@export var on_hit: Array[OnHitData] = []
@export_range(0, 10, 1) var mining_power: int = 1
@export_range(0.0, 1000.0, 0.001, "or_greater", "suffix:px/s") var speed: float = 400.0
@export_range(-10.0, 10.0, 0.001, "suffix:rad/s") var rotation_speed: float = 0.0
@export_range(1.0, 100.0, 1.0, "suffix:px") var collision_radius: float = 1.0
@export_range(0, 100, 1, "suffix:hits") var pierce: int = 0

@export var track_nearest_enemy: bool = false
@export_range(0.1, 10.0, 0.001, "suffix:rad/s") var track_rotate_speed: float = 1.0
@export_range(1.0, 10000.0, 1.0, "suffix:px") var tracking_radius: float = 100.0
@export var override_rotation_with_tracking: bool = false
@export var spawn_at_collision: PackedScene = null

@export var hit_enemies: bool = true
@export var hit_resource_piles: bool = true
@export var hit_terrain: bool = true
