extends Sprite2D


var dialogue: Array[String] = [
	"Hello there!",
	"Don't mind me, I'm just enjoying my new shell!"
]

func _on_interactable_area_interacted_with() -> void:
	NarrativeUtility.queue_dialogue(dialogue, "Hermit")
