class_name GameWorld
extends Node2D


signal biome_changed(new_biome: BiomeData)

const POD_TRAIN_SCENE := preload("uid://c2lhusb0r1cs1")

var prohibit_biome_change: bool = false
var biome_data: BiomeData = load("uid://bsbh3wtb4m8dr")
var player_train: PodTrain = null
var _camera_padding: int = 80

@onready var _biome: Biome = $InnerReef
@onready var hud: HUD = $HUD
@onready var spawn_marker: Marker2D = $SpawnMarker
@onready var darkness: CanvasModulate = $Darkness
@onready var camera: Camera2D = $Camera


func _ready() -> void:
	darkness.show()
	construct_player_train()
	camera.reset_smoothing()
	
	var inventory := PlayerUtility.get_inventory()
	inventory.item_added.connect(_on_inventory_item_added)
	inventory.item_removed.connect(_on_inventory_item_removed)


func construct_player_train() -> void:
	player_train = POD_TRAIN_SCENE.instantiate()
	add_child(player_train)
	
	var pod_setup := PlayerUtility.get_pod_setup()
	player_train.construct(pod_setup, spawn_marker.global_position)
	
	var remote_transform := RemoteTransform2D.new()
	player_train.get_primary_pod().add_child(remote_transform)
	remote_transform.remote_path = remote_transform.get_path_to(camera)
	
	update_camera_limits()


func get_biome() -> Biome:
	return _biome


func add_to_biome(node: Node2D, pos: Vector2) -> void:
	node.position = pos
	if node is Enemy:
		_biome.add_enemy(node as Enemy)
	else:
		_biome.add_child(node)


func change_biome(new_biome_data: BiomeData, spawn_pos_index: int) -> void:
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
	
	var primary_pod := player_train.get_primary_pod()
	var position_difference := _biome.get_spawn_position(spawn_pos_index) - primary_pod.global_position
	for pod in player_train.get_all_pods():
		pod.global_position += position_difference
	primary_pod.velocity = Vector2.ZERO
	
	var announcement := biome_data.name
	hud.display_announcement(announcement)
	game.transition_screen.fade_from_black()
	biome_changed.emit(biome_data)
	
	# Bug fix for instantly changing again on arriving, due to detection using old position
	await get_tree().create_timer(0.01, false).timeout
	prohibit_biome_change = false
	
	# Needs to wait for remote transform to update
	update_camera_limits()
	camera.reset_smoothing()


func update_camera_limits() -> void:
	var bounds := _biome.bounds.get_rect()
	camera.limit_left = int(bounds.position.x) + _camera_padding
	camera.limit_right = int(bounds.position.x + bounds.size.x) - _camera_padding
	camera.limit_top = int(bounds.position.y) + _camera_padding
	camera.limit_bottom = int(bounds.position.y + bounds.size.y) - _camera_padding


func _on_player_train_primary_pod_destroyed() -> void:
	var game := GameUtility.get_game()
	game.game_over()


func _on_inventory_item_added(item_data: ItemData, count: int) -> void:
	player_train.notification_container.display_notification(item_data, count)


func _on_inventory_item_removed(item_data: ItemData, count: int) -> void:
	player_train.notification_container.display_notification(item_data, -count)
