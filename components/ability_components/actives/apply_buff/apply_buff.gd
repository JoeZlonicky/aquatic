@tool
extends AbilityActive


enum ApplyTo {
	SELF,
	IN_FRONT,
	ALL,
	ALL_OTHERS,
	PRIMARY_POD
}

@export_category("Required")
@export var buff_data: PodBuffData:
	set(value):
		buff_data = value
		update_configuration_warnings()
@export var apply_to: ApplyTo = ApplyTo.SELF
@export var activate_on_ready: bool = false

var buffs: Array[PodBuff] = []


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	pod.destroyed.connect(_on_pod_destroyed)
	
	if not activate_on_ready:
		return
	
	await pod.train.constructed
	activate()


func activate() -> void:
	if apply_to == ApplyTo.SELF:
		_apply_buff_to(pod)
	elif apply_to == ApplyTo.IN_FRONT:
		var in_front := pod.train.get_pod_in_front(pod.train_index)
		_apply_buff_to(in_front)
	elif apply_to == ApplyTo.ALL:
		for p in pod.train.get_all_pods():
			_apply_buff_to(p)
	elif apply_to == ApplyTo.ALL_OTHERS:
		for p in pod.train.get_all_pods():
			if pod == p:
				continue
			_apply_buff_to(p)
	elif apply_to == ApplyTo.PRIMARY_POD:
		var primary_pod := pod.train.get_primary_pod()
		_apply_buff_to(primary_pod)


func end() -> void:
	while buffs:
		var buff: PodBuff = buffs.pop_front()
		buff.queue_free()


func _apply_buff_to(p: Pod) -> void:
	if not p:
		return
	
	var buff := p.apply_buff(buff_data)
	buffs.append(buff)


func _on_pod_destroyed() -> void:
	end()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := ConfigurationWarnings.any_properties_not_set(self, ["buff_data"])
	var base_warnings := super._get_configuration_warnings()
	return warnings + base_warnings
