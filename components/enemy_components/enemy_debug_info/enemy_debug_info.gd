@tool
extends VBoxContainer


@export var _enemy: Enemy:
	set(value):
		_enemy = value
		update_configuration_warnings()

@export_range(1, 100) var max_damage_notifications: int = 10

var _damage_taken: int = 0
var _time_in_combat: float = 0.0

@onready var damage_taken_label: Label = $Labels/DamageTakenLabel
@onready var dps_label: Label = $Labels/DPSLabel
@onready var chill_label: Label = $Labels/ChillLabel

@onready var damage_container: VBoxContainer = $DamageContainer
@onready var reset_timer: Timer = $ResetTimer


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_enemy.health.damaged.connect(_on_health_damaged)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var chill := _enemy.statuses.chill
	if not chill:
		chill_label.text = ""
	else:
		chill_label.text = "Chill: " + str(chill._stacks) + "/" + str(chill._stacks_to_freeze)
		
	if reset_timer.is_stopped():
		return
	
	_time_in_combat += delta


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	# Cancel out rotation
	rotation = -_enemy.rotation


func _on_health_damaged(amount: int) -> void:
	# Track total damage
	_damage_taken += amount
	damage_taken_label.text = "Damage Taken: " + str(_damage_taken)
	
	# Show individual damage amounts
	var damage_notification := Label.new()
	damage_notification.add_theme_font_size_override("font_size", 36)
	damage_notification.text = str(amount)
	damage_notification.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	damage_container.add_child(damage_notification)
	
	# Fade damage amounts
	var fade := damage_notification.create_tween()
	fade.tween_property(damage_container, "modulate:a", 1.0, 1.0)  # Wait 1s
	fade.tween_property(damage_notification, "modulate:a", 0.0, 1.0)
	
	# Cap damage amounts
	while damage_container.get_child_count() > max_damage_notifications:
		var oldest := damage_container.get_child(0)
		damage_container.remove_child(oldest)
		oldest.queue_free()
	
	if _time_in_combat < 1.0:
		dps_label.text = "DPS: " + str(_damage_taken) + "/s"
	else:
		dps_label.text = "DPS: " + str(int(_damage_taken / _time_in_combat)) + "/s"
	
	# Reset after not taking damage for X seconds
	reset_timer.start()


func _on_reset_timer_timeout() -> void:
	_damage_taken = 0
	damage_taken_label.text = "Damage Taken: " + str(_damage_taken)
	_time_in_combat = 0.0
	dps_label.text = "DPS: 0/s"


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["_enemy"])
