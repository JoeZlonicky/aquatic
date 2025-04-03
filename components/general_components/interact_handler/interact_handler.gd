@tool
class_name InteractHandler
extends Area2D


@export var interactor: Node2D:
	set(i):
		interactor = i
		update_configuration_warnings()

var _interactables_in_range: Array[InteractableArea] = []
var _closest: InteractableArea = null


func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	
	if not _closest or not event.is_action_pressed("interact"):
		return
	
	_closest.interact_with(interactor)
	get_viewport().set_input_as_handled()


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	_update_closest()


func _update_closest() -> void:
	var closest_distance_squared := INF
	var closest_interactable: InteractableArea = null
	for interactable in _interactables_in_range:
		var pos := interactable.global_position
		var distance_squared := global_position.distance_squared_to(pos)
		if not closest_interactable or distance_squared < closest_distance_squared:
			closest_interactable = interactable
			closest_distance_squared = distance_squared
	_set_new_closest(closest_interactable)


# Okay to use with null or the current closest
func _set_new_closest(new_closet: InteractableArea) -> void:
	if _closest == new_closet:
		return
	
	if _closest:
		_closest.update_prioritized(false)
	_closest = new_closet
	if _closest:
		_closest.update_prioritized(true)


func _on_area_entered(interactable: InteractableArea) -> void:
	_interactables_in_range.push_back(interactable)
	_update_closest()


func _on_area_exited(interactable: InteractableArea) -> void:
	_interactables_in_range.erase(interactable)
	_update_closest()


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ['interactor'])
