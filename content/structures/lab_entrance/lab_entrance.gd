extends Sprite2D


const LAB_MENU_SCENE := preload("uid://wlniudjnedgt")

@onready var pod_light: PointLight2D = $PodLight


func _on_interactable_area_interacted_with(_by: Node2D) -> void:
	GameUtility.get_game().pause_input_counter += 1
	PlayerUtility.get_player_train().queue_free()
	pod_light.show()
	
	var lab_menu := LAB_MENU_SCENE.instantiate() as LabMenu
	add_child(lab_menu)
	lab_menu.closed.connect(_on_lab_menu_closed)


func _on_lab_menu_closed() -> void:
	pod_light.hide()
	GameUtility.get_game().pause_input_counter -= 1
	GameUtility.get_game_world().construct_player_train()
