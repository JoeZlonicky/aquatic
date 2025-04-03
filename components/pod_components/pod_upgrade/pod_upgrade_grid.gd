class_name PodUpgradeGrid
extends GridContainer


signal updated

const PREREQ_LINE_WIDTH: float = 16.0

var tech_tree: TechTree
var inventory: Inventory
var buttons: Dictionary[PodUpgradeData, UpgradeButton] = {}
var lines: Node2D


func _ready() -> void:
	lines = Node2D.new()
	add_child(lines)
	move_child(lines, 0)


func setup(pod_data: PodData) -> void:
	var game := GameUtility.get_game()
	tech_tree = game.owned_pods[pod_data]
	inventory = PlayerUtility.get_inventory()
	
	for child in get_children():
		var upgrade_button := child as UpgradeButton
		if not upgrade_button:
			continue
		
		var f := _on_upgrade_button_used.bind(upgrade_button.upgrade)
		upgrade_button.used.connect(f)
		buttons[upgrade_button.upgrade] = upgrade_button


func update() -> void:
	clear_lines()
	for upgrade: PodUpgradeData in buttons:
		var button: UpgradeButton = buttons[upgrade]
		update_button(button)
	updated.emit()


func update_button(button: UpgradeButton) -> void:
	button.update(tech_tree, inventory)
	
	var prereq := button.upgrade.unlock_prereq
	if not prereq:
		return
	
	# Wait for position to be finalized in container
	await get_tree().process_frame
	await get_tree().process_frame
	
	var other_button: UpgradeButton = buttons[prereq]
	var start := button.get_global_rect().get_center()
	var end := other_button.get_global_rect().get_center()
	var met: bool = button.upgrade.is_prereq_satisfied(tech_tree)
	add_line(start, end, !met)


func clear_lines() -> void:
	for line in lines.get_children():
		line.queue_free()


func add_line(start: Vector2, end: Vector2, is_negative: bool) -> void:
	var line := Line2D.new()
	line.width = PREREQ_LINE_WIDTH
	lines.add_child(line)
	line.add_point(lines.to_local(start))
	line.add_point(lines.to_local(end))
	if is_negative:
		line.default_color = Color.INDIAN_RED


func _on_upgrade_button_used(new_tier: int, upgrade: PodUpgradeData) -> void:
	var costs := upgrade.get_item_costs(new_tier)
	for item_cost in costs:
		inventory.remove_item(item_cost.item, item_cost.quantity)
	tech_tree.update_tier(upgrade, new_tier)
	update()
