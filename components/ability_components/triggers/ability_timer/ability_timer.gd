@tool
class_name AbilityTimer
extends Node


@export_category("Required")
@export var pod: Pod:
	set(value):
		pod = value
		update_configuration_warnings()

@export_category("Optional")
@export var abilities: Array[AbilityActive] = []
@export var play_sfx: AudioStreamPlayer2D = null

@export_range(0.01, 999.0, 0.001, "suffix:s") var cooldown: float = 1.0
@export var running: bool = true
@export var use_efficiency: bool = true

@export var ability_indiciator: PodAbilityIndicator = null:
	set(value):
		ability_indiciator = value
		_update_ability_indicator_color()
@export_color_no_alpha var ability_color: Color = Color.WHITE:
	set(value):
		ability_color = value
		_update_ability_indicator_color()
@export var require_nearest_to_activate: NearestInArea = null

var timer: float = 0.0


func _ready() -> void:
	_update_ability_indicator_color()


func _process(delta: float) -> void:
	if Engine.is_editor_hint() or not running:
		return
	
	if not pod.get_health().is_alive():
		_update_ability_indicator_fill(0.0)
		return
	
	timer += delta * calc_speed_modifier()
	
	if require_nearest_to_activate and not require_nearest_to_activate.get_nearest():
		_update_ability_indicator_fill(timer / cooldown)
		return
	
	if timer > cooldown:
		timer = 0.0
		_on_timeout()
	
	_update_ability_indicator_fill(timer / cooldown)


func calc_speed_modifier() -> float:
	var modified_cooldown := pod.get_stats().calc_modified_cooldown(cooldown)
	var modifier := cooldown / modified_cooldown
	return modifier


func resume() -> void:
	running = true
	if ability_indiciator:
		ability_indiciator.set_fill_color(ability_color)


func start() -> void:
	running = true
	timer = 0.0
	if ability_indiciator:
		ability_indiciator.set_fill_color(ability_color)


func stop() -> void:
	running = false


func _on_timeout() -> void:
	for ability in abilities:
		ability.activate()
	if play_sfx:
		play_sfx.play()
	pod.emit_ability_triggered()


func _update_ability_indicator_fill(value: float) -> void:
	if not ability_indiciator:
		return
	ability_indiciator.set_fill(value)


func _update_ability_indicator_color() -> void:
	if ability_indiciator and ability_indiciator.is_node_ready():
		ability_indiciator.set_fill_color(ability_color)


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["pod"])
