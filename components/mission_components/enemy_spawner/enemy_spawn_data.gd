class_name EnemySpawnData
extends Resource


@export var enemy_data: EnemyData
@export var spawn_rate_over_threat_level: Curve
@export_range(1, 50, 1) var enemies_per_spawn: int = 1
