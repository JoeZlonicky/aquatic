class_name Game
extends Node2D


const GAME_WORLD_SCENE_PATH := "uid://d12ummtmpg0gj"
const ITEMS_LOST_ON_GAME_OVER: float = 0.66

@export var pod_setup: Array[PodData]

var inventory := Inventory.new()
var owned_pods: Dictionary[PodData, TechTree] = {}
var pause_input_counter: int = 0

@onready var current_scene: CanvasItem = $GameWorld
@onready var transition_screen: TransitionScreen = $TransitionScreen
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var dialogue_overlay: DialogueOverlay = $DialogueOverlay


func _ready() -> void:
	for pod_data in pod_setup:
		owned_pods[pod_data] = TechTree.new()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		pause_menu.show()
		get_viewport().set_input_as_handled()


func swap_pod_order(first_idx: int, second_idx: int) -> void:
	var temp := pod_setup[first_idx]
	pod_setup[first_idx] = pod_setup[second_idx]
	pod_setup[second_idx] = temp


func fade_to_new_scene(scene_path: String) -> void:
	get_tree().paused = true
	
	await transition_screen.fade_to_black()
	current_scene.queue_free()
	
	var new_scene := load(scene_path) as PackedScene
	current_scene = new_scene.instantiate()
	add_child(current_scene)
	move_child(current_scene, 0)
	
	get_tree().paused = false
	transition_screen.fade_from_black()


func game_over() -> void:
	await fade_to_new_scene(GAME_WORLD_SCENE_PATH)
	GameUtility.get_game_world().hud.display_announcement("Recovered")
	for item_data: ItemData in inventory.get_items():
		var count := inventory.get_item_count(item_data)
		var lost := ceili(float(count) * ITEMS_LOST_ON_GAME_OVER)
		inventory.remove_item(item_data, lost)
