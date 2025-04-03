@tool
extends GPUParticles2D


@export var _pod: Pod:
	set(p):
		_pod = p
		update_configuration_warnings()


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_pod.destroyed.connect(_on_pod_destroyed)


func _on_pod_destroyed() -> void:
	emitting = true


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["_pod"])
