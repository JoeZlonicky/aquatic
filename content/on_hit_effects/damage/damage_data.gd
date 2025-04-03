class_name DamageData
extends OnHitData


const CRIT_PARTICLES_SCENE := preload("uid://bplboghqngmo5")

@export var amount: int = 10
@export var can_crit: bool = true


func apply(enemy: Enemy, pod: Pod, source_pos: Vector2) -> void:
	var modifier: float = 1.0
	var stats := pod.get_stats()
	
	var is_crit := stats.crit_chance >= randf_range(1.0, 100.0)
	if is_crit:
		_spawn_crit_particles(source_pos, enemy.global_position)
		modifier *= stats.crit_muliplier
	
	var damage := roundi(float(amount) * modifier) + stats.flat_damage_bonus
	enemy.take_damage(damage)


func _spawn_crit_particles(source_pos: Vector2, enemy_pos: Vector2) -> void:
	var particles := CRIT_PARTICLES_SCENE.instantiate() as GPUParticles2D
	particles.rotation = source_pos.angle_to_point(enemy_pos)
	GameUtility.add_to_biome(particles, enemy_pos)
