class_name DialoguePopup
extends Label


@export_range(1, 999, 1, "suffix:s") var min_cooldown: int = 20
@export_range(2, 999, 1, "suffix:s") var max_cooldown: int = 100
@export_range(1, 999, 1, "suffix:s") var dialogue_display_time: int = 6
@export var auto_start: bool = true

@export_multiline var dialogue: Array[String]

@onready var timer: Timer = $Timer
@onready var display_timer: Timer = $DisplayTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	text = ""
	display_timer.wait_time = dialogue_display_time
	
	if auto_start:
		start_cooldown()


func display_dialogue(dialogue_text: String) -> void:
	text = dialogue_text
	animation_player.play("fade_in")
	display_timer.start()
	start_cooldown()


func start_cooldown() -> void:
	var next_cooldown: int = randi_range(min_cooldown, max_cooldown)
	timer.wait_time = next_cooldown
	timer.start()


func set_paused(is_paused: bool) -> void:
	if is_paused:
		timer.stop()
	elif timer.is_stopped():
		timer.start()


func display_next_dialogue() -> void:
	if dialogue.is_empty():
		display_dialogue("")
	else:
		var next: String = dialogue.pick_random()
		display_dialogue(next)


func _on_timer_timeout() -> void:
	display_next_dialogue()


func _on_display_timer_timeout() -> void:
	animation_player.play("fade_out")
