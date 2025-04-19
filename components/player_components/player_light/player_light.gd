class_name PlayerLight
extends PointLight2D


@export_range(0.0, 1.0, 0.001) var biome_tint_strength: float = 0.5


func _ready() -> void:
	await get_tree().process_frame
	_update_tint()


func _update_tint() -> void:
	var new_tint := GameUtility.get_game().light_tint
	color = Color.WHITE.lerp(new_tint, biome_tint_strength)
