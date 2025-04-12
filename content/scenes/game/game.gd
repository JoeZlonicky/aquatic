class_name Game
extends Node2D


const GAME_WORLD_SCENE_PATH := "uid://d12ummtmpg0gj"

var inventory := Inventory.new()
var pause_input_counter: int = 0

@onready var current_scene: CanvasItem = $GameWorld
@onready var transition_screen: TransitionScreen = $TransitionScreen
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var dialogue_overlay: DialogueOverlay = $DialogueOverlay


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		pause_menu.show()
		get_viewport().set_input_as_handled()


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
