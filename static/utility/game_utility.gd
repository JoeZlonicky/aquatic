class_name GameUtility


static func get_game() -> Game:
	var scene_tree := Engine.get_main_loop() as SceneTree
	var game := scene_tree.current_scene as Game
	assert(game, "Trying to get game at an invalid time")
	return game


static func get_game_world() -> GameWorld:
	var game := get_game()
	var world := game.current_scene as GameWorld
	assert(world, "Trying to get world at an invalid time")
	return world


static func is_in_game_world() -> bool:
	var scene_tree := Engine.get_main_loop() as SceneTree
	var game := scene_tree.current_scene as Game
	if not game:
		return false
	
	return game.current_scene is GameWorld


static func get_current_biome() -> Biome:
	var world := get_game_world()
	return world.get_biome()


static func add_to_biome(node: Node2D, pos: Vector2) -> void:
	var world := get_game_world()
	world.add_to_biome(node, pos)


static func one_shot_and_reparent_audio_player_2d(audio_player: AudioStreamPlayer2D) -> void:
	var game := get_game()
	audio_player.reparent(game)
	audio_player.play()
	audio_player.finished.connect(audio_player.queue_free)


# check_after_time is a safe-guard against finished not being emitted sometimes
static func one_shot_and_reparent_particles(particles: GPUParticles2D,
		check_after_time: float = 5.0) -> void:
	var biome := get_current_biome()
	particles.reparent(biome)
	particles.one_shot = true
	particles.emitting = true
	particles.finished.connect(particles.queue_free)
	
	await particles.get_tree().create_timer(check_after_time, false).timeout
	if is_instance_valid(particles):
		particles.queue_free()
