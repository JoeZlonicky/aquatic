class_name Game
extends Node2D


const GAME_WORLD_SCENE_PATH := "uid://d12ummtmpg0gj"

var inventory := Inventory.new()
var pause_input_counter: int = 0

@export_color_no_alpha var light_tint: Color

@onready var biome: Biome = $InnerReef
@onready var _bounds_skirt: BoundsSkirt = $World/BoundsSkirt
@onready var transition_screen: TransitionScreen = $TransitionScreen
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var dialogue_overlay: DialogueOverlay = $DialogueOverlay
@onready var game_camera: GameCamera = $Player/GameCamera


func _ready() -> void:
	_update_camera_limits()
	game_camera.reset_smoothing()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		pause_menu.show()
		get_viewport().set_input_as_handled()


func add_to_world(node: Node2D, pos: Vector2) -> void:
	add_child(node)
	node.global_position = pos


func _update_camera_limits() -> void:
	var bounds := biome.bounds.get_global_rect()
	game_camera.update_limits(bounds)
	_bounds_skirt.update_bounds(bounds)
