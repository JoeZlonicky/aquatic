extends DevOverlayDropdown


const BIOMES_FOLDER = "res://content/biomes"

var loaded_biomes: Array[BiomeData] = []


func setup() -> void:
	var biome_paths := FileUtility.get_all_files_under_folder(BIOMES_FOLDER, ".tres")
	
	for path in biome_paths:
		var data := load(path) as BiomeData
		if data == null:
			continue
		
		loaded_biomes.append(data)
	
	for data in loaded_biomes:
		add_to_menu(data.name, _change_to_biome.bind(data))


func _change_to_biome(biome_data: BiomeData) -> void:
	while not GameUtility.is_in_game_world():
		var game_scene := load("uid://x8lmoly7d6ei") as PackedScene
		get_tree().change_scene_to_packed(game_scene)
		
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		
	var game_world := GameUtility.get_game_world()
	game_world.change_biome(biome_data, 0)
