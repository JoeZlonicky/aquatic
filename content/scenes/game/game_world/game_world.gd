class_name GameWorld
extends Node2D


signal biome_changed(new_biome: BiomeData)

var prohibit_biome_change: bool = false
var biome_data: BiomeData = load("uid://bsbh3wtb4m8dr")

@onready var _biome: Biome = $InnerReef
@onready var _bounds_skirt: BoundsSkirt = $BoundsSkirt
@onready var hud: HUD = $HUD
@onready var darkness: CanvasModulate = $Darkness
@onready var game_camera: GameCamera = $Player/GameCamera
@onready var player: Player = $Player


func _ready() -> void:
	darkness.show()
	_update_camera_limits()
	game_camera.reset_smoothing()
	
	var inventory := PlayerUtility.get_inventory()
	inventory.item_added.connect(_on_inventory_item_added)
	inventory.item_removed.connect(_on_inventory_item_removed)


func get_biome() -> Biome:
	return _biome


func add_to_biome(node: Node2D, pos: Vector2) -> void:
	node.position = pos
	_biome.add_child(node)


func change_biome(new_biome_data: BiomeData, _spawn_pos_index: int) -> void:
	if prohibit_biome_change:
		return
	
	var game := GameUtility.get_game()
	
	prohibit_biome_change = true
	get_tree().paused = true
	await game.transition_screen.fade_to_black()
	get_tree().paused = false
	
	biome_data = new_biome_data
	
	var new_biome := biome_data.scene.instantiate()
	add_child(new_biome)
	move_child(new_biome, _biome.get_index())
	_biome.queue_free()
	_biome = new_biome
	
	var announcement := biome_data.name
	hud.display_announcement(announcement)
	game.transition_screen.fade_from_black()
	biome_changed.emit(biome_data)
	
	# Bug fix for instantly changing again on arriving, due to detection using old position
	await get_tree().create_timer(0.01, false).timeout
	prohibit_biome_change = false
	
	# Needs to wait for remote transform to update
	_update_camera_limits()
	game_camera.reset_smoothing()


func _update_camera_limits() -> void:
	var bounds := _biome.bounds.get_global_rect()
	game_camera.update_limits(bounds)
	_bounds_skirt.update_bounds(bounds)


func _on_inventory_item_added(item_data: ItemData, count: int) -> void:
	player.notification_container.display_notification(item_data, count)


func _on_inventory_item_removed(item_data: ItemData, count: int) -> void:
	player.notification_container.display_notification(item_data, -count)
