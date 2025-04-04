@tool
class_name AbilityDurationTimer
extends Node


@export_category("Required")
@export var pod: Pod:
	set(value):
		pod = value
		update_configuration_warnings()

@export_category("Optional")
@export var abilities: Array[AbilityActive] = []
@export var sfx_on_duration_start: AudioStreamPlayer2D = null
@export var sfx_on_duration_end: AudioStreamPlayer2D = null

@export_range(0.01, 999.0, 0.001, "suffix:s") var cooldown: float = 1.0
@export_range(0.01, 999.0, 0.001, "suffix:s") var duration: float = 1.0
@export var running: bool = true

@export var ability_indiciator: PodAbilityIndicator = null:
	set(value):
		ability_indiciator = value
		_update_ability_indicator_color()
@export_color_no_alpha var cooldown_ability_color: Color = Color.WHITE:
	set(value):
		cooldown_ability_color = value
		_update_ability_indicator_color()
@export_color_no_alpha var duration_ability_color: Color = Color.WHITE


var timer: float = 0.0
var is_duration_active: bool = false


func _ready() -> void:
	_update_ability_indicator_color()


func _process(delta: float) -> void:
	if Engine.is_editor_hint() or not running:
		return
	
	if not pod.get_health().is_alive():
		_update_ability_indicator_fill(0.0)
		return
	
	if is_duration_active:
		timer += delta
	else:
		timer += delta * calc_speed_modifier()
	
	if timer > cooldown:
		timer = fmod(timer, cooldown)
		if is_duration_active:
			_on_duration_end()
		else:
			_on_duration_start()
	
	if is_duration_active:
		_update_ability_indicator_fill(1.0 - timer / cooldown)
	else:
		_update_ability_indicator_fill(timer / cooldown)


func calc_speed_modifier() -> float:
	var modified_cooldown := pod.get_stats().calc_modified_cooldown(cooldown)
	var modifier := cooldown / modified_cooldown
	return modifier


func resume() -> void:
	running = true
	if ability_indiciator:
		ability_indiciator.set_fill_color(cooldown_ability_color)


func start() -> void:
	running = true
	timer = 0.0
	if ability_indiciator:
		ability_indiciator.set_fill_color(cooldown_ability_color)


func stop() -> void:
	running = false


func _on_duration_start() -> void:
	for ability in abilities:
		ability.activate()
	if sfx_on_duration_start:
		sfx_on_duration_start.play()
	if ability_indiciator:
		ability_indiciator.set_fill_color(duration_ability_color)
	is_duration_active = true
	pod.emit_ability_triggered()


func _on_duration_end() -> void:
	for ability in abilities:
		ability.end()
	if sfx_on_duration_end:
		sfx_on_duration_end.play()
	if ability_indiciator:
		ability_indiciator.set_fill_color(cooldown_ability_color)
	is_duration_active = false


func _update_ability_indicator_fill(value: float) -> void:
	if not ability_indiciator:
		return
	ability_indiciator.set_fill(value)


func _update_ability_indicator_color() -> void:
	if ability_indiciator and ability_indiciator.is_node_ready():
		ability_indiciator.set_fill_color(cooldown_ability_color)


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["pod"])
