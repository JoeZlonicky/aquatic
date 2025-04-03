extends Node


func _ready() -> void:
	if !OS.is_debug_build():
		queue_free()
		return


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_1"):
		damage_second_pod()
	elif event.is_action_pressed("debug_12"):
		get_tree().reload_current_scene()


func damage_second_pod() -> void:
	var train := PlayerUtility.get_player_train()
	var second := train.get_pod(1)
	if second:
		second.damage(1)
