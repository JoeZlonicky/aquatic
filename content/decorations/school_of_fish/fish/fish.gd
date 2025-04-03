class_name Fish
extends CharacterBody2D


@export_range(1.0, 1000.0, 1.0, "suffix:px") var patrol_distance: float = 200.0
@export_range(1.0, 500.0, 0.001, "suffix:px/s") var patrol_speed: float = 50.0
@export_range(1.0, 100.0, 1.0, "suffix:px") var flee_distance: float = 50.0
@export_range(1.0, 2000.0, 0.001, "suffix:px/s") var flee_speed: float = 400.0

var current_distance: float = patrol_distance

var is_startled: bool = false
var is_fleeing: bool = false

@onready var patrol_origin := global_position
@onready var sprite: Node2D = $Sprite
@onready var wait_timer: Timer = $WaitTimer


func _ready() -> void:
	var direction := 1.0 if randf() > 0.5 else -1.0
	velocity.x = direction * patrol_speed
	position.x += randf_range(-patrol_distance, patrol_distance)
	_update_rotation()


func _physics_process(_delta: float) -> void:
	if (not wait_timer.is_stopped() or is_startled) and not is_fleeing:
		return
	
	_update_rotation()
	_patrol_update()
	move_and_slide()


func startle() -> void:
	is_startled = true


func reset_startle() -> void:
	is_startled = false


func flee() -> void:
	is_fleeing = true
	velocity.x = sign(velocity.x) * flee_speed
	current_distance = flee_distance
	_update_rotation()
	
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)


func _patrol_update() -> void:
	if velocity.x > 0.0 and global_position.x - patrol_origin.x > current_distance:
		_invert_velocity()
	elif velocity.x < 0.0 and patrol_origin.x - global_position.x > current_distance:
		_invert_velocity()


func _invert_velocity() -> void:
	velocity *= -1.0
	if not is_fleeing:
		wait_timer.start()


func _update_rotation() -> void:
	rotation = velocity.angle()
	if velocity.x > 0.0:
		sprite.scale.x = 1.0
	elif velocity.x < 0.0:
		rotation += PI
		sprite.scale.x = -1.0
