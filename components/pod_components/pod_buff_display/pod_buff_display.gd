@tool
extends HBoxContainer


const BUFF_ICON_SCENE := preload("uid://knyghv1e7i77")

@export var _pod: Pod:
	set(value):
		_pod = value
		update_configuration_warnings()


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_pod.buff_applied.connect(_on_pod_buff_applied)


func _on_pod_buff_applied(buff: PodBuff) -> void:
	var icon_texture := buff.data.icon
	if not icon_texture:
		return
	
	var icon: TextureRect = BUFF_ICON_SCENE.instantiate()
	icon.texture = icon_texture
	icon.modulate = buff.data.modulate
	add_child(icon)
	buff.tree_exited.connect(icon.queue_free)


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["_pod"])
