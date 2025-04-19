class_name NarrativeUtility


static func queue_dialogue(dialogue: Array[String], title: String = "") -> bool:
	assert(dialogue.size() > 0, "Empty dialogue")
	
	var game := GameUtility.get_game()
	var dialogue_overlay := game.dialogue_overlay
	for entry: String in dialogue.slice(0, -1):
		dialogue_overlay.queue_dialogue(entry, title)
	
	var last_entry: String = dialogue.back()
	await dialogue_overlay.queue_dialogue(last_entry, title)
	return true
