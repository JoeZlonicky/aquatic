class_name ExplosionData
extends Resource


@export var on_hit: Array[OnHitData] = []
@export_range(0, 10) var mining_power: int = 0
@export_range(1.0, 500.0, 0.001, "suffix:px") var collision_radius: float = 100.0
@export_range(0.05, 1.0, 0.001, "suffix:s") var active_duration: float = 0.05

@export_range(0, 5, 1) var n_sub_iterations: int = 0
@export_range(1, 10, 1) var n_sub_explosions: int = 1
@export_range(0.0, 1.0, 0.001, "suffix:s") var time_between_iterations: float = 0.1
@export_range(0.0, 0.5, 0.001, "suffix:s") var time_between_sub_explosions: float = 0.0
@export_range(0.0, 1000.0, 1.0, "suffix:px") var distance_per_sub_explosion: float = 100.0

@export var spawn_at_explosion: PackedScene = null
