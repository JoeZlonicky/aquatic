class_name PodMoveSpeedModifier
extends PodModifier


@export var max_speed_modifier: float = 0.0


func apply(pod: Pod) -> void:
	var controller := get_move_controller(pod)
	controller.max_speed += max_speed_modifier


func unapply(pod: Pod) -> void:
	var controller := get_move_controller(pod)
	controller.max_speed -= max_speed_modifier


func get_move_controller(pod: Pod) -> PlayerMoveController:
	var dash_pod := pod as DashPod
	return dash_pod.player_move_controller
