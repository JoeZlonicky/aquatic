class_name InteractableArea
extends Area2D


signal interacted_with(by: Node2D)

@export var show_when_prioritized: CanvasItem

var _is_prioritized: bool = false


func _ready() -> void:
	if not show_when_prioritized:
		return
	
	show_when_prioritized.hide()


func interact_with(by: Node2D) -> void:
	interacted_with.emit(by)


func update_prioritized(prioritized: bool) -> void:
	_is_prioritized = prioritized
	if not show_when_prioritized:
		return
	
	show_when_prioritized.visible = _is_prioritized
