extends Biome


var npc_name: String = "The Scientist"
var start_mission_dialogue: Array[String] = [
	"I'm glad you're here!",
	"I was trying to collect mushroom specimens when my pod broke down",
	"I can try to start it back up, but it's going to draw some attention...",
	"Cover for me!"
]
var post_mission_dialogue: Array[String] = [
	"I couldn't have done it without you!"
]

@onready var protect_mission: ProtectMission = $ProtectMission
@onready var npc_interactable_area: InteractableArea = $ProtectMission/NPCInteractableArea


func _on_npc_interactable_area_interacted_with(_by: Node2D) -> void:
	if protect_mission.finished:
		NarrativeUtility.queue_dialogue(post_mission_dialogue, npc_name)
		return
	
	await NarrativeUtility.queue_dialogue(start_mission_dialogue, npc_name)
	npc_interactable_area.process_mode = Node.PROCESS_MODE_DISABLED
	protect_mission.start()


func _on_protect_mission_completed() -> void:
	npc_interactable_area.process_mode = Node.PROCESS_MODE_INHERIT
