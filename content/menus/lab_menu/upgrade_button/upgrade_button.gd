@tool
class_name UpgradeButton
extends Button


signal used(new_tier: int)

@export var upgrade: PodUpgradeData:
	set(u):
		upgrade = u
		if is_node_ready():
			update_static_text()
			update_tier_text()
		update_configuration_warnings()

var current_tier: int = 0

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var description_label: Label = $VBoxContainer/DescriptionLabel
@onready var cost_label: Label = $VBoxContainer/CostLabel
@onready var tier_label: Label = $VBoxContainer/TierLabel


func _ready() -> void:
	update_static_text()


func update_static_text() -> void:
	title_label.text = upgrade.name if upgrade else "Title"
	description_label.text = upgrade.description if upgrade else "Description"


func update(tech_tree: TechTree, inventory: Inventory) -> void:
	current_tier = tech_tree.get_current_tier(upgrade)
	update_tier_text()
	update_cost_label(inventory)
	
	var max_tier := upgrade.get_n_tiers()
	var has_prereq := upgrade.is_prereq_satisfied(tech_tree)
	disabled = current_tier >= max_tier or not has_prereq or not can_afford(inventory)


func update_tier_text() -> void:
	var max_tier := upgrade.get_n_tiers()
	tier_label.text = str(current_tier) + "/" + str(max_tier)


func can_afford(inventory: Inventory) -> bool:
	var costs := upgrade.get_item_costs(current_tier + 1)
	for item_cost in costs:
		if not item_cost.can_afford(inventory):
			return false
	
	return true


func update_cost_label(inventory: Inventory) -> void:
	var costs := upgrade.get_item_costs(current_tier + 1)
	cost_label.visible = not costs.is_empty()
	
	if can_afford(inventory):
		cost_label.modulate = Color.WHITE
	else:
		cost_label.modulate = Color.INDIAN_RED
	
	var parts: Array[String]
	for item_cost in costs:
		parts.append(str(item_cost.quantity) + " " + item_cost.item.name)
	cost_label.text = "Cost: " + ", ".join(parts)


func _on_pressed() -> void:
	used.emit(current_tier + 1)


func _get_configuration_warnings() -> PackedStringArray:
	return ConfigurationWarnings.any_properties_not_set(self, ['upgrade'])
