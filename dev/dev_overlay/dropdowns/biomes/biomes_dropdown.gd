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


func _change_to_biome(_biome_data: BiomeData) -> void:
	pass
