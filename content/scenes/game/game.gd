class_name Game
extends Node2D


var inventory := Inventory.new()
var pause_input_counter: int = 0

@export_color_no_alpha var light_tint: Color

@onready var player: Player = $Player
@onready var bounds: ColorRect = $World/Bounds
@onready var _bounds_skirt: BoundsSkirt = $World/BoundsSkirt
@onready var transition_screen: TransitionScreen = %TransitionScreen
@onready var pause_menu: CanvasLayer = %PauseMenu
@onready var dialogue_overlay: DialogueOverlay = %DialogueOverlay
@onready var game_camera: GameCamera = %GameCamera
@onready var darkness: CanvasModulate = $World/Global/Darkness


func _ready() -> void:
	_update_camera_limits()
	game_camera.reset_smoothing()
	darkness.show()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		pause_menu.show()
		get_viewport().set_input_as_handled()


func add_to_world(node: Node2D, pos: Vector2) -> void:
	node.global_position = pos
	add_child(node)


func _update_camera_limits() -> void:
	var world_bounds := bounds.get_global_rect()
	game_camera.update_limits(world_bounds)
	_bounds_skirt.update_bounds(world_bounds)
