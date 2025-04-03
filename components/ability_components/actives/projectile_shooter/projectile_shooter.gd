@tool
class_name ProjectileShooter
extends AbilityActive


@export_category("Required")
@export var sprite: Texture:
	set(value):
		sprite = value
		update_configuration_warnings()
@export var sprite_modulate: Color = Color.WHITE
@export var projectile_data: ProjectileData:
	set(value):
		projectile_data = value
		update_configuration_warnings()

@export_category("Optional")
@export var create_trail_particles: bool = true
@export var trigger_explosion_on_hit: ExplosionGenerator = null
@export var spawn_pos_override: Node2D = null
@export var track_nearest: NearestInArea = null
@export var play_audio: AudioStreamPlayer2D = null


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint() or not pod.get_health().is_alive():
		return
	
	if track_nearest:
		look_at_nearest()


func look_at_nearest() -> void:
	var nearest := track_nearest.get_nearest()
	if not nearest:
		return
	
	var target_pos := nearest.global_position
	if nearest is CharacterBody2D:
		# Lead the target
		# Currently very rough approximation of where the two will intersect
		var distance := global_position.distance_to(target_pos)
		var time_to_arrive := distance / projectile_data.speed
		target_pos += (nearest as CharacterBody2D).velocity * time_to_arrive
	
	rotation = global_position.angle_to_point(target_pos)


func activate() -> void:
	if track_nearest:
		look_at_nearest()
	
	var pos := global_position
	if spawn_pos_override:
		pos = spawn_pos_override.global_position
	
	var direction := Vector2.from_angle(rotation)
	var projectile := Projectile.create(projectile_data, pod, pos, direction)
	projectile.rotation = rotation
	projectile.hit.connect(_on_projectile_hit)
	
	var s := Sprite2D.new()
	s.texture = sprite
	s.modulate = sprite_modulate
	projectile.add_child(s)


func _on_projectile_hit(at: Vector2) -> void:
	if trigger_explosion_on_hit:
		trigger_explosion_on_hit.activate_at(at)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := ConfigurationWarnings.any_properties_not_set(self,
		["pod", "sprite", "projectile_data"])
	var base_warnings := super._get_configuration_warnings()
	return warnings + base_warnings
