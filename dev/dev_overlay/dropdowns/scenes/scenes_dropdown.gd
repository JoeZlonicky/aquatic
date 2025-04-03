extends DevOverlayDropdown


var scenes: Dictionary[String, String] = {
	"Game" : "uid://x8lmoly7d6ei",
	"Main menu" : "uid://bakwr4c717cru"
}


func setup() -> void:
	add_to_menu("Reload current", get_tree().reload_current_scene)
	add_spacer()
	
	for scene_name: String in scenes:
		var path: String = scenes[scene_name]
		add_to_menu(scene_name, _change_scene.bind(path))


func _change_scene(scene_path: String) -> void:
	var scene := load(scene_path) as PackedScene
	get_tree().change_scene_to_packed(scene)
