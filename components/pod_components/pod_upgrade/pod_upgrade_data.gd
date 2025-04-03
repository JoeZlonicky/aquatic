class_name PodUpgradeData
extends Resource


@export var name: String
@export var description: String
@export var tiers: Array[PodUpgradeTierData]
@export var unlock_prereq: PodUpgradeData
@export var unlock_prereq_tier: int = 1


func apply(pod: Pod, current_tier: int) -> void:
	_apply_or_unapply(pod, current_tier, true)


func unapply(pod: Pod, current_tier: int) -> void:
	_apply_or_unapply(pod, current_tier, false)


func change_tier(pod: Pod, old_tier: int, new_tier: int) -> void:
	unapply(pod, old_tier)
	apply(pod, new_tier)


func get_n_tiers() -> int:
	return tiers.size()


func get_item_costs(tier: int) -> Array[ItemCost]:
	if tier > tiers.size():
		return []
	
	return tiers[tier - 1].item_costs


func is_prereq_satisfied(tech_tree: TechTree) -> bool:
	if not unlock_prereq:
		return true
	
	var prereq_tier := tech_tree.get_current_tier(unlock_prereq)
	return prereq_tier >= unlock_prereq_tier


func _apply_or_unapply(pod: Pod, current_tier: int, do_apply: bool) -> void:
	var tier := tiers[current_tier - 1]
	for modifier in tier.modifiers:
		if do_apply:
			modifier.apply(pod)
		else:
			modifier.unapply(pod)
