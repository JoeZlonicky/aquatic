@tool
class_name PodCapsule
extends Sprite2D


const DESTROYED_MODULATE := Color(0.2, 0.2, 0.2)

@export var _pod: Pod:
	set(value):
		_pod = value
		update_configuration_warnings()

@export_color_no_alpha var primary_color: Color = Color.WHITE:
	set(value):
		primary_color = value
		update_appearance()
@export_color_no_alpha var pilot_color: Color = Color.WHITE:
	set(value):
		pilot_color = value
		update_appearance()
@export var armor_sprite: Texture:
	set(value):
		armor_sprite = value
		update_appearance()
@export var costume_sprite: Texture:
	set(value):
		costume_sprite = value
		update_appearance()
@export_range(-20.0, 20.0, 1.0, "suffix:px") var pilot_y_offset: float = 0.0:
	set(value):
		pilot_y_offset = value
		update_appearance()

var pilot_move_radius: float = 20.0
var pilot_head_move_speed: float = 100.0
var pilot_body_move_speed: float = 25.0

@onready var head: Sprite2D = $Head
@onready var body: Sprite2D = $Body
@onready var costume: Sprite2D = $Head/Costume
@onready var front: Sprite2D = $Front
@onready var armor: Sprite2D = $FlashSprite/Armor

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	update_appearance()
	if Engine.is_editor_hint():
		return
	
	_pod.get_health().damaged.connect(_on_pod_health_damaged)
	_pod.destroyed.connect(_on_pod_destroyed)
	_pod.revived.connect(_on_pod_revived)


func update_appearance() -> void:
	if not is_node_ready():
		return
	
	head.self_modulate = pilot_color
	body.self_modulate = pilot_color
	head.position.y = pilot_y_offset
	body.position.y = pilot_y_offset
	
	costume.texture = costume_sprite
	armor.texture = armor_sprite
	
	front.modulate = primary_color
	self_modulate = primary_color
	


func update_look_direction(direction: Vector2, delta: float) -> void:
	head.position = head.position.move_toward(direction * pilot_move_radius, 
		pilot_head_move_speed * delta)
	body.position = body.position.move_toward(head.position, 
		pilot_body_move_speed * delta)


func _on_pod_health_damaged(_amount: int) -> void:
	if not _pod.get_health().is_alive:
		return
	
	animation_player.play("hit")


func _on_pod_destroyed() -> void:
	modulate = DESTROYED_MODULATE


func _on_pod_revived() -> void:
	modulate = Color.WHITE


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ["_pod"])
