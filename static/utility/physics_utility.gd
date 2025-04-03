class_name PhysicsUtility


static func create_ability_collision_mask(terrain: bool,
		resource_piles: bool, enemies: bool) -> int:
	var collision_mask: int = 0
	if terrain:
		collision_mask |= 1
	if resource_piles:
		collision_mask |= 8
	if enemies:
		collision_mask |= 64
	return collision_mask


static func create_circle_collision_shape(radius: float) -> CollisionShape2D:
	var collision_shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = radius
	collision_shape.shape = circle
	return collision_shape
