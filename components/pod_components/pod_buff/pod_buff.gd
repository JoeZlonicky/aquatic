class_name PodBuff
extends Node


@export var pod: Pod
@export var data: PodBuffData


func _ready() -> void:
	data.modifier.apply(pod)


func _exit_tree() -> void:
	data.modifier.unapply(pod)
