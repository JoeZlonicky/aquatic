class_name CorruptedGate
extends Node2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $Blocker/CollisionShape2D


func close() -> void:
	collision_shape.disabled = false
	animation_player.play("close")


func open() -> void:
	collision_shape.disabled = true
	animation_player.play("open")
