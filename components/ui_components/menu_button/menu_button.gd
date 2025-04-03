extends Button


const EXTRA_SPRITES_SPACING: int = 10

@onready var sprites_container: HBoxContainer = $SpritesContainer


func _ready() -> void:
	_update_sprites_container_gap()
	sprites_container.hide()


func _update_sprites_container_gap() -> void:
	var width := roundi(get_rect().size.x)
	sprites_container.add_theme_constant_override("separation",
		width + EXTRA_SPRITES_SPACING)


func _on_gui_input(_event: InputEvent) -> void:
	if not has_focus():
		grab_focus()


func _on_item_rect_changed() -> void:
	if not is_node_ready():
		return
	_update_sprites_container_gap()


func _on_focus_entered() -> void:
	sprites_container.visible = true
	sprites_container.modulate = get_theme_color("font_hover_color")


func _on_focus_exited() -> void:
	sprites_container.visible = false


func _on_button_down() -> void:
	sprites_container.modulate = get_theme_color("font_pressed_color")


func _on_button_up() -> void:
	sprites_container.modulate = get_theme_color("font_hover_color")
