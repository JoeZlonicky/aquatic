class_name PodTrain
extends Node2D


signal primary_pod_destroyed
signal constructed

const FOLLOW_TARGET_SCENE := preload("uid://dt4tqgkmjgcc8")
const FIRST_FOLLOW_DISTANCE: float = 160.0
const STANDARD_FOLLOW_DISTANCE: float = 130.0
const CONSTRUCT_DIRECTION: Vector2 = Vector2.LEFT

var pods: Array[Pod] = []  # Goes from head to tail

@onready var notification_container: NotificationContainer = $NotificationContainer


func construct(setup: Array[PodData], pos: Vector2) -> void:
	var pod_progression := GameUtility.get_game().owned_pods
	var pod_index: int = 0
	var previous_pod: Pod = null
	
	for pod_data in setup:
		var pod: Pod = pod_data.scene.instantiate()
		pod.train = self
		pod.train_index = pod_index
		pods.append(pod)
		
		add_child(pod)
		move_child(pod, 0)
		
		if pod_index == 0:
			pod.global_position = pos
			pod.destroyed.connect(_on_primary_pod_destroyed)
			notification_container.reparent(pod, false)
		else:
			var follow_distance := STANDARD_FOLLOW_DISTANCE
			if pod_index == 1:
				follow_distance = FIRST_FOLLOW_DISTANCE
			_add_follow_target(pod, previous_pod, follow_distance)
		
		var tech_tree: TechTree = pod_progression.get(pod_data, null)
		var upgrades := tech_tree.get_all_tiered_upgrades() if tech_tree else []
		for upgrade: PodUpgradeData in upgrades:
			var tier := tech_tree.get_current_tier(upgrade)
			upgrade.apply(pod, tier)
		
		previous_pod = pod
		pod_index += 1
	
	constructed.emit()


func _add_follow_target(pod: Pod, target: Node2D, distance: float) -> void:
	var follow := FOLLOW_TARGET_SCENE.instantiate() as FollowTarget
	follow.node = pod
	follow.target = target
	follow.follow_distance = distance
	pod.global_position = target.global_position + CONSTRUCT_DIRECTION * distance
	pod.add_child(follow)


func get_primary_pod() -> Pod:
	if pods.size() == 0:
		return null
	
	return pods[0]


func get_all_pods() -> Array[Pod]:
	return pods


func get_pod(i: int) -> Pod:
	if i >= pods.size() - 1 or i < 0:
		return null
	
	return pods[i]


func get_pod_behind(i: int) -> Pod:
	return get_pod(i + 1)


func get_pod_in_front(i: int) -> Pod:
	return get_pod(i - 1)


func _on_primary_pod_destroyed() -> void:
	primary_pod_destroyed.emit()
