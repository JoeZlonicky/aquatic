@tool
extends Node2D


@onready var chase_player: ChasePlayer = $ChasePlayer
@onready var flash_sprite_on_hit: Sprite2D = $FlashSpriteOnHit
@onready var fade_sprite_in: Node = $FlashSpriteOnHit/FadeSpriteIn


func _ready() -> void:
	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_components_not_set([chase_player, 
		flash_sprite_on_hit, fade_sprite_in])
