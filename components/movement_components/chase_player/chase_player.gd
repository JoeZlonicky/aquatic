@tool
class_name ChasePlayer
extends Node2D


@export var _character: CharacterBody2D:
	set(c):
		_character = c
		update_configuration_warnings()
@export var _statuses: Statuses:
	set(s):
		_statuses = s
		update_configuration_warnings()

@export_range(0.0, 1000.0, 0.001, "or_greater", "suffix:px/s") var move_speed: float = 300.0
@export_range(1.0, 100.0, 0.001, "suffix:rad/s") var rotation_speed: float = 30.0


var target: Node2D = null


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	await get_tree().process_frame
	target = PlayerUtility.get_primary_pod()


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() or not _statuses.can_move() or not target:
		return
	
	_character.rotation = rotate_toward(_character.rotation, 
		global_position.angle_to_point(target.global_position), 
		rotation_speed * delta)
	
	var speed := move_speed * _statuses.get_move_speed_modifier()
	_character.velocity = Vector2.from_angle(_character.rotation) * speed
	_character.move_and_slide()


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["_character", "_statuses"])
