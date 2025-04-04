extends CanvasLayer


var is_fading: bool = false

@onready var animation_player: AnimationPlayer = $FadeScreen/AnimationPlayer
@onready var _subtitle_label: Label = %SubtitleLabel


func _ready() -> void:
	_subtitle_label.text = ProjectConfig.get_release_name()


func _input(event: InputEvent) -> void:
	if is_fading or event.is_action("fullscreen_toggle"):
		return
	
	if not (event is InputEventKey or
			event is InputEventJoypadButton or
			event is InputEventMouseButton):
		return
	
	animation_player.play("fade_to_black")
	is_fading = true
	
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file("uid://x8lmoly7d6ei")
