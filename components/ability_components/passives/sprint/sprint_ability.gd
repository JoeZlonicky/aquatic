@tool
class_name SprintAbility
extends Node


@export var pod: Pod:
	set(value):
		pod = value
		update_configuration_warnings()
@export var player_move_controller: PlayerMoveController:
	set(value):
		player_move_controller = value
		update_configuration_warnings()
@export var ability_indicator: PodAbilityIndicator:
	set(value):
		ability_indicator = value
		update_configuration_warnings()
@export_color_no_alpha var ability_color: Color = Color.WHITE:
	set(value):
		ability_color = value
		if ability_indicator:
			ability_indicator.set_fill_color(ability_color)

@export_range(1, 240, 1, "suffix:s/60") var max_stamina: int = 60 * 2
@export_range(0.1, 10.0, 0.001) var stamina_recharge_multiplier: float = 1.0
@export_range(0.0, 3000.0, 0.001, "suffix:px/s²") var add_acceleration: float = 2000.0
@export_range(0.0, 1000.0, 0.001, "suffix:px/s") var add_speed: float = 550.0
@export_range(0.0, 10.0, 0.001, "suffix:s") var recovery_cooldown: float = 1.0

var is_sprinting: bool = false
var stamina := max_stamina
var recharge_timer := Timer.new()
var recovery_cooldown_timer := Timer.new()


func _ready() -> void:
	if ability_indicator:
		ability_indicator.set_fill_color(ability_color)
	if Engine.is_editor_hint():
		return
	
	recovery_cooldown_timer.wait_time = recovery_cooldown
	recovery_cooldown_timer.one_shot = true
	add_child(recovery_cooldown_timer)
	
	recharge_timer.autostart = true
	recharge_timer.wait_time = stamina_recharge_multiplier / 60.0
	add_child(recharge_timer)
	recharge_timer.timeout.connect(_on_recharge_timer_timeout)


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var sprint_input := InputUtility.is_primary_action_pressed()
	
	if sprint_input and not is_sprinting and stamina:
		activate_sprint()
	elif is_sprinting and (not sprint_input or not stamina):
		deactivate_sprint()
	
	if is_sprinting:
		stamina -= 1
		recharge_timer.paused = true
		recovery_cooldown_timer.start()
	elif recovery_cooldown_timer.is_stopped():
		recharge_timer.paused = false
	
	ability_indicator.set_fill(float(stamina) / float(max_stamina))


func activate_sprint() -> void:
	player_move_controller.max_speed += add_speed
	player_move_controller.acceleration += add_acceleration
	player_move_controller.auto_move = true
	is_sprinting = true


func deactivate_sprint() -> void:
	player_move_controller.max_speed -= add_speed
	player_move_controller.acceleration -= add_acceleration
	player_move_controller.auto_move = false
	is_sprinting = false


func _on_recharge_timer_timeout() -> void:
	stamina = min(stamina + 1, max_stamina)


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["pod", 
		"player_move_controller", "ability_indicator"])
