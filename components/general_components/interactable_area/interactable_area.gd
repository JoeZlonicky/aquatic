class_name InteractableArea
extends Area2D
## An [Area2D] that reacts to [InteractHandler].


## Emitted when interacted with.
signal interacted_with

## [b]Optional:[/b] toggles visibility when prioritized by an [InteractHandler].
@export var _show_when_prioritized: CanvasItem

var _is_prioritized: bool = false


func _ready() -> void:
	if not _show_when_prioritized:
		return
	
	_show_when_prioritized.hide()


## Expected to be called by an [InteractHandler] to trigger an interaction.
func interact_with() -> void:
	assert(_is_prioritized)
	interacted_with.emit()


## Expected to be called by an [InteractHandler] to manage prioritization.
func update_prioritized(prioritized: bool) -> void:
	_is_prioritized = prioritized
	if not _show_when_prioritized:
		return
	
	_show_when_prioritized.visible = _is_prioritized
