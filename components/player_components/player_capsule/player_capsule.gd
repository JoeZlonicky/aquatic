@tool
class_name PlayerCapsule
extends Sprite2D


@export_color_no_alpha var primary_color: Color = Color.WHITE:
	set(value):
		primary_color = value
		update_appearance()
@export_color_no_alpha var pilot_color: Color = Color.WHITE:
	set(value):
		pilot_color = value
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


func _ready() -> void:
	update_appearance()


func update_appearance() -> void:
	if not is_node_ready():
		return
	
	head.self_modulate = pilot_color
	body.self_modulate = pilot_color
	head.position.y = pilot_y_offset
	body.position.y = pilot_y_offset
	
	costume.texture = costume_sprite
	
	front.modulate = primary_color
	self_modulate = primary_color


func update_look_direction(direction: Vector2, delta: float) -> void:
	head.position = head.position.move_toward(direction * pilot_move_radius, 
		pilot_head_move_speed * delta)
	body.position = body.position.move_toward(head.position, 
		pilot_body_move_speed * delta)
