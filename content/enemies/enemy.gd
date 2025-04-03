@tool
class_name Enemy
extends CharacterBody2D

@export var health: Health:
	set(h):
		health = h
		update_configuration_warnings()
@export var statuses: Statuses:
	set(s):
		statuses = s
		update_configuration_warnings()


func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	health.died.connect(_on_health_died)


func take_damage(amount: int = 1) -> void:
	var modifier := statuses.get_vulnerability()
	var damage := roundi(float(amount) * modifier)
	health.deal_damage(damage)


func _on_health_died() -> void:
	queue_free()


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["health", "statuses"])
