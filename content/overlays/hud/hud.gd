class_name HUD
extends CanvasLayer


@onready var announcement_text: Label = $AnnouncementText
@onready var announcement_animation_player: AnimationPlayer = $AnnouncementText/AnimationPlayer


func display_announcement(text: String) -> void:
	announcement_text.text = text
	announcement_animation_player.play("fade")
