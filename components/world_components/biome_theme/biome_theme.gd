@tool
extends Node


@export_color_no_alpha var light_color: Color = Color.WHITE:
	set(value):
		light_color = value
		_update_theme()
		
@export_color_no_alpha var dark_color: Color = Color.GRAY:
	set(value):
		dark_color = value
		_update_theme()

@export_category("Themed components")
@export var background_color: ColorRect
@export var water_particles: WaterParticles
@export var terrain_layer: TileMapLayer
@export var silhouette_layer: TileMapLayer
@export var water_shader: WaterShader


func _ready() -> void:
	_update_theme()


func _update_theme() -> void:
	if background_color:
		background_color.color = light_color
	if water_particles:
		water_particles.modulate = light_color
	if terrain_layer:
		terrain_layer.modulate = dark_color
	if silhouette_layer:
		silhouette_layer.modulate = dark_color
	if water_shader:
		water_shader.color = light_color
