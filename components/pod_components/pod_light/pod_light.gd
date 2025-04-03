extends PointLight2D


@export_range(0.0, 1.0, 0.001) var biome_tint_strength: float = 0.5


func _ready() -> void:
	await get_tree().process_frame
	_update_tint()
	GameUtility.get_game_world().biome_changed.connect(_on_biome_changed)


func _update_tint() -> void:
	var new_tint := GameUtility.get_game_world().biome_data.light_tint
	color = Color.WHITE.lerp(new_tint, biome_tint_strength)


func _on_biome_changed(_new_biome_data: BiomeData) -> void:
	_update_tint()
