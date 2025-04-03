class_name ProtectMission
extends Node2D


signal completed

@export var duration_seconds: float = 120.0
@export var enemy_spawners: Array[EnemySpawner] = []
@export var mission_reward: MissionReward
@export var corrupted_gate: CorruptedGate
@export var kill_enemies_on_completed: bool = true

var started: bool = false
var finished: bool = false
var mission_lines: Array[String] = [
	"Keep them busy!",
	"It's going as fast as it can!",
	"I'm going to owe you one!",
	"I'm lucky you arrived!",
	"Come on..."
]

@onready var duration_timer: Timer = $DurationTimer
@onready var dialogue_popup: DialoguePopup = $DialoguePopup
@onready var progress_bar: TextureRect = $ProgressBar


func _ready() -> void:
	duration_timer.wait_time = duration_seconds
	for spawner in enemy_spawners:
		spawner.set_enabled(false)


func _process(_delta: float) -> void:
	if finished:
		update_progress_bar(1.0)
		return
	
	if not started:
		update_progress_bar(0.0)
		return
	
	var time_ratio := clampf(duration_timer.time_left / duration_timer.wait_time,
		0.0, 1.0)
	time_ratio = 1.0 - time_ratio
	for spawner in enemy_spawners:
		spawner.current_threat_level = time_ratio
	
	update_progress_bar(time_ratio)


func start() -> void:
	started = true
	dialogue_popup.dialogue = mission_lines
	dialogue_popup.display_next_dialogue()
	
	duration_timer.start()
	for spawner in enemy_spawners:
		spawner.set_enabled(true)
	if corrupted_gate:
		corrupted_gate.close()


func update_progress_bar(done_ratio: float) -> void:
	progress_bar.set_instance_shader_parameter("fill_ratio", done_ratio)


func _on_duration_timer_timeout() -> void:
	dialogue_popup.set_paused(true)
	finished = true
	
	if mission_reward:
		mission_reward.grant_reward()
	if corrupted_gate:
		corrupted_gate.open()
	for spawner in enemy_spawners:
		spawner.set_enabled(false)
	GameUtility.get_game_world().hud.display_announcement("Mission Completed")
	
	completed.emit()
	
	if not kill_enemies_on_completed:
		return
	
	# Kill multiple times in-case there are enemies spawned on dying
	for i in 3:
		GameUtility.get_current_biome().kill_all_enemies()
		await get_tree().create_timer(0.01, false).timeout
