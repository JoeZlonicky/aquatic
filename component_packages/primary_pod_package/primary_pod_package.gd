@tool
extends Node2D


@onready var interact_handler: InteractHandler = $InteractHandler
@onready var player_move_controller: PlayerMoveController = $PlayerMoveController


func _ready() -> void:
	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_components_not_set([interact_handler, 
		player_move_controller])
