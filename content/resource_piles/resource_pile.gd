@tool
class_name ResourcePile
extends StaticBody2D


@export var dropped_resource: ItemData:
	set(dr):
		dropped_resource = dr
		update_configuration_warnings()

@export_range(1, 999, 1) var total_resources: int = 3
@export_range(1, 999, 1) var required_mine_strength: int = 1

@onready var texture_button: TextureButton = $TextureButton
@onready var highlight_sprite: Sprite2D = $TextureButton/HighlightSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hit_sfx: AudioStreamPlayer2D = $HitSFX
@onready var harvested_sfx: AudioStreamPlayer2D = $HarvestedSFX

@onready var total_health: Health = $TotalHealth
@onready var health_per_resource: Health = $HealthPerResource



func try_to_mine(power: int) -> void:
	if power < required_mine_strength:
		animation_player.play("mine_failed")
		return
	
	animation_player.play("mined")
	health_per_resource.deal_damage(power)
	
	if health_per_resource.is_alive():
		hit_sfx.play()
		return
	
	total_health.deal_damage(1)
	ItemPickup.create.call_deferred(dropped_resource, global_position)
	
	if total_health.is_alive():
		health_per_resource.heal_to_full()
		harvested_sfx.play()
		return
	
	GameUtility.one_shot_and_reparent_audio_player_2d(harvested_sfx)
	queue_free()


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["dropped_resource"])
