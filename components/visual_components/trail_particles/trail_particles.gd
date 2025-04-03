extends GPUParticles2D


@export_category("Optional")
@export var _reparent_on_death: Health = null

## Helpful for nodes that persist (e.g. pod trail particles)
@export var _restart_on_biome_change: bool = false


func _ready() -> void:
	if _reparent_on_death:
		_reparent_on_death.died.connect(_on_node_died)
		return
	
	if _restart_on_biome_change:
		# Wait for game world to be ready
		await get_tree().process_frame
		GameUtility.get_game_world().biome_changed.connect(_on_biome_changed)


func _on_biome_changed(_new_biome_data: BiomeData) -> void:
	restart()


func _on_node_died() -> void:
	GameUtility.one_shot_and_reparent_particles(self)
