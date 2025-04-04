extends Node
## Intended to be run as the main scene of the project


@export var _debug_main_scene: PackedScene
@export var _release_main_scene: PackedScene
@export var _min_window_size: Vector2i
@export_color_no_alpha var _render_clear_color: Color = Color.BLACK


func _ready() -> void:
	_initial_config()
	_launch_start_scene()


func _initial_config() -> void:
	RenderingServer.set_default_clear_color(_render_clear_color)
	get_window().min_size = _min_window_size


func _launch_start_scene() -> void:
	if OS.is_debug_build():
		get_tree().change_scene_to_packed.call_deferred(_debug_main_scene)
	else:
		get_tree().change_scene_to_packed.call_deferred(_release_main_scene)
