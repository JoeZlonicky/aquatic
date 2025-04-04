@tool
extends GPUParticles2D


@export var _health: Health:
	set(value):
		_health = value
		update_configuration_warnings()


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_health.died.connect(_on_health_died)


func _on_health_died() -> void:
	GameUtility.one_shot_and_reparent_particles(self)


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ['_health'])
