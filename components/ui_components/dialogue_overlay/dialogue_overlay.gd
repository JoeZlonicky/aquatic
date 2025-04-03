class_name DialogueOverlay
extends CanvasLayer


class QueuedDialogue:
	signal started
	signal finished
	
	var title: String = ""
	var dialogue: String = ""
	
	func _init(p_dialogue: String, p_title: String = "") -> void:
		title = p_title
		dialogue = p_dialogue


var current_dialogue: QueuedDialogue = null
var queued_dialogue: Array[QueuedDialogue] = []

@onready var title_label: Label = %TitleLabel
@onready var dialogue_label: TypedLabel = %DialogueLabel
@onready var title_box_container: PanelContainer = $MarginContainer/DialogueContainer/DialogueBoxContainer/TitleBoxContainer
@onready var margin_container: MarginContainer = $MarginContainer
@onready var dialogue_container: HBoxContainer = $MarginContainer/DialogueContainer
@onready var next_prompt: Control = %NextPrompt


func _unhandled_input(event: InputEvent) -> void:
	if not visible or not event.is_action_pressed("interact"):
		return
	
	if current_dialogue and dialogue_label.is_typing():
		dialogue_label.skip_to_end()
	else:
		_next_dialogue()
	get_viewport().set_input_as_handled()


func queue_dialogue(dialogue: String, title: String = "") -> bool:
	var q_dialogue := QueuedDialogue.new(dialogue, title)
	queued_dialogue.push_back(q_dialogue)
	if not current_dialogue:
		_next_dialogue()
	await q_dialogue.finished
	return true


func _next_dialogue() -> void:
	next_prompt.modulate = Color.TRANSPARENT
	if current_dialogue:
		current_dialogue.finished.emit()
	
	if not queued_dialogue:
		current_dialogue = null
		GameUtility.get_game().pause_input_counter -= 1
		hide()
		return
	
	current_dialogue = queued_dialogue.pop_front()
	dialogue_label.text = current_dialogue.dialogue
	dialogue_label.start_typing()
	title_label.text = current_dialogue.title
	title_label.visible = current_dialogue.title.length() > 0
	current_dialogue.started.emit()
	if not visible:
		_animate_first_dialogue()
		GameUtility.get_game().pause_input_counter += 1
	
	show()


func _animate_first_dialogue() -> void:
	# Kinda gross but we need to wait for UI to update after being shown
	# By using modulate, instead of hiding, the UI is still correct but doesn't show yet
	margin_container.modulate = Color.TRANSPARENT
	await get_tree().process_frame
	await get_tree().process_frame
	var dialogue_center := dialogue_container.get_global_rect().get_center()
	margin_container.pivot_offset = dialogue_center
	margin_container.modulate = Color.WHITE
	
	var tween := create_tween()
	tween.tween_property(margin_container, "scale", Vector2.ONE,
		0.15).from(Vector2.ZERO)


func _on_dialogue_label_finished() -> void:
	next_prompt.modulate = Color.WHITE
