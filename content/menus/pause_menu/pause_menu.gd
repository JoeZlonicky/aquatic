extends CanvasLayer


const AUDIO_LEVEL_PER_PRESS: int = 20  # Should a divisor of 100

var _music_level: int = 100
var _sfx_level: int = 100

@onready var options: VBoxContainer = $Options
@onready var continue_button: Button = $Options/ContinueButton
@onready var settings_button: Button = $Options/SettingsButton
@onready var quit_button: Button = $Options/QuitButton

@onready var confirm_quit: VBoxContainer = $ConfirmQuit
@onready var confirm_button: Button = $ConfirmQuit/ConfirmButton

@onready var settings: VBoxContainer = $Settings
@onready var music_button: Button = $Settings/MusicButton
@onready var sfx_button: Button = $Settings/SFXButton


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("pause"):
		_close()
		get_viewport().set_input_as_handled()
		return
	
	if event.is_action_pressed("ui_cancel"):
		if settings.visible:
			_on_settings_back_button_pressed()
		elif confirm_quit.visible:
			_on_cancel_button_pressed()
		else:
			_close()


func _close() -> void:
	get_tree().paused = false
	options.show()
	settings.hide()
	confirm_quit.hide()
	hide()


func _on_continue_button_pressed() -> void:
	_close()


func _on_settings_button_pressed() -> void:
	options.hide()
	settings.show()
	music_button.grab_focus()


func _on_quit_button_pressed() -> void:
	options.hide()
	confirm_quit.show()
	confirm_button.grab_focus()


func _on_confirm_button_pressed() -> void:
	get_tree().quit()


func _on_cancel_button_pressed() -> void:
	options.show()
	confirm_quit.hide()
	quit_button.grab_focus()


func _on_visibility_changed() -> void:
	if visible:
		continue_button.grab_focus()


func _on_fullscreen_button_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_settings_back_button_pressed() -> void:
	settings.hide()
	options.show()
	settings_button.grab_focus()


func _on_godot_license_button_pressed() -> void:
	OS.shell_open("https://godotengine.org/license/")


func _on_music_button_pressed() -> void:
	if _music_level == 0:
		_music_level = 100
	else:
		_music_level -= AUDIO_LEVEL_PER_PRESS
	music_button.text = "Music: " + str(_music_level) + "%"
	
	var bus_idx := AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(_music_level / 100.0))


func _on_sfx_button_pressed() -> void:
	if _sfx_level == 0:
		_sfx_level = 100
	else:
		_sfx_level -= AUDIO_LEVEL_PER_PRESS
	sfx_button.text = "SFX: " + str(_sfx_level) + "%"
	
	var bus_idx := AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(_sfx_level / 100.0))
