class_name FullscreenToggle
extends Node
## Toggles between windowed and fullscreen when input action is pressed


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("fullscreen_toggle"):
		return
	
	var is_fullscreen := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
