class_name TechTree
extends RefCounted


var _upgrades: Dictionary[PodUpgradeData, int] = {}  # tier starts at 1


func update_tier(upgrade: PodUpgradeData, new_tier: int) -> void:
	if new_tier == 0:
		_upgrades.erase(upgrade)
	else:
		_upgrades[upgrade] = new_tier


# Returns 0 if you don't have an upgrade
# Starts at 1 if you do
func get_current_tier(upgrade: PodUpgradeData) -> int:
	return _upgrades.get(upgrade, 0)


func has_upgrade(upgrade: PodUpgradeData) -> bool:
	return _upgrades.has(upgrade)


func get_all_tiered_upgrades() -> Array:
	return _upgrades.keys()
