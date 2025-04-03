class_name InputUtility


static func is_primary_action_pressed() -> bool:
	if GameUtility.get_game().pause_input_counter > 0:
		return false
	
	return Input.is_action_pressed("primary_action")


static func get_move_vector() -> Vector2:
	if GameUtility.get_game().pause_input_counter > 0:
		return Vector2.ZERO
	
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
