class_name ItemPickupNotification
extends Label


var displayed_item_data: ItemData = null
var n_displayed: int = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func display(item_data: ItemData, n: int) -> void:
	displayed_item_data = item_data
	n_displayed = n
	animation_player.play("fade")
	refresh()


func add_to_displayed(n: int) -> void:
	n_displayed += n
	refresh()


func refresh() -> void:
	text = str(n_displayed) + "x " + displayed_item_data.name
	# Self modulate because animation affects normal modulate
	if n_displayed > 0:
		self_modulate = Color.WHITE
	else:
		self_modulate = Color.INDIAN_RED
	animation_player.seek(0.0, true)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
