@tool
extends Node


enum ActivatedPod {
	SELF,
	IN_FRONT,
	ALL,
	ALL_OTHERS,
	PRIMARY_POD
}

@export_category("Required")
@export var pod: Pod:
	set(p):
		pod = p
		update_configuration_warnings()

@export_category("Config")
@export var abilities: Array[AbilityActive] = []
@export var activated_pod: ActivatedPod = ActivatedPod.IN_FRONT
@export var play_sfx: AudioStreamPlayer2D = null


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	await pod.train.constructed
	
	if activated_pod == ActivatedPod.SELF:
		_hook_up_pod(pod)
	elif activated_pod == ActivatedPod.IN_FRONT:
		var in_front := pod.train.get_pod_in_front(pod.train_index)
		_hook_up_pod(in_front)
	elif activated_pod == ActivatedPod.ALL:
		for p in pod.train.get_all_pods():
			_hook_up_pod(p)
	elif activated_pod == ActivatedPod.ALL_OTHERS:
		for p in pod.train.get_all_pods():
			if pod == p:
				continue
			_hook_up_pod(p)
	elif activated_pod == ActivatedPod.PRIMARY_POD:
		var primary_pod := pod.train.get_primary_pod()
		_hook_up_pod(primary_pod)


func _hook_up_pod(p: Pod) -> void:
	if not p:
		return
	
	p.ability_triggered.connect(_on_ability_triggered)


func _on_ability_triggered() -> void:
	if not pod.get_health().is_alive():
		return
	
	for ability in abilities:
		ability.activate()
	if play_sfx:
		play_sfx.play()
	
	pod.emit_ability_triggered()


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["pod"])
