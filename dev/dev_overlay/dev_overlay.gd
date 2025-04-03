extends CanvasLayer


@onready var dropdowns_container: BoxContainer = $Panel/MarginContainer/Dropdowns


func _ready() -> void:
	if !OS.is_debug_build():
		queue_free()
		return
	
	hide()
	
	for dropdown: DevOverlayDropdown in dropdowns_container.get_children():
		dropdown.setup()
		dropdown.pressed.connect(_on_dropdown_pressed.bind(dropdown))


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("dev_overlay"):
		return
	
	visible = not visible


func _on_dropdown_pressed(pressed_dropdown: DevOverlayDropdown) -> void:
	for dropdown: DevOverlayDropdown in dropdowns_container.get_children():
		if dropdown == pressed_dropdown:
			continue
		
		dropdown.button_pressed = false
