class_name SFXOnDamaged
extends AudioStreamPlayer2D
## [AudioStreamPlayer2D] that starts playing when [Health] is damaged


## Health to watch for damage
@export var _health: Health


func _ready() -> void:
	if not _health:
		push_warning(ConfigurationWarnings.missing_required_properties(self))
		return
	
	_health.damaged.connect(_on_health_damaged)


func _on_health_damaged(_amount: int) -> void:
	playing = true
