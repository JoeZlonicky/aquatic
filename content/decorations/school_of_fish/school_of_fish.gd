extends Node2D


const FISH_SCENE := preload("uid://cfun6x8u7trhj")

var has_flee_triggered: bool = false
var school: Array[Fish] = []

@onready var spawn_points: Node2D = $SpawnPoints
@onready var startle_area: Area2D = $StartleArea


func _ready() -> void:
	spawn_school()


func spawn_school() -> void:
	for point: Node2D in spawn_points.get_children():
		var fish := FISH_SCENE.instantiate() as Fish
		GameUtility.add_to_biome(fish, point.global_position)
		school.append(fish)


func _on_startle_area_body_entered(_body: Node2D) -> void:
	for fish in school:
		fish.startle()


func _on_startle_area_body_exited(_body: Node2D) -> void:
	if startle_area.has_overlapping_bodies():
		return
	
	for fish in school:
		fish.reset_startle()


func _on_flee_area_body_entered(_body: Node2D) -> void:
	if has_flee_triggered:
		return
	
	for fish in school:
		fish.flee()  # Will free themselves
	
	school.clear()  # Don't track them anymore
	has_flee_triggered = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if not has_flee_triggered:
		return
	
	has_flee_triggered = false
	spawn_school()
