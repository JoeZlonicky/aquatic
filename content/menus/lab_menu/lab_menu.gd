class_name LabMenu
extends CanvasLayer


signal closed

const GAME_WORLD_SCENE_PATH := "uid://d12ummtmpg0gj"
const POD_BUTTON_SCENE := preload("uid://r714o3x45a00")
const SWAP_BUTTON_SCENE := preload("uid://c6mvi60l0qd33")

@onready var pod_name: Label = %PodName
@onready var pod_description: Label = %PodDescription
@onready var inventory_label: Label = %InventoryLabel
@onready var upgrade_grid_container: Container = %UpgradeGridContainer
@onready var switch_buttons: HBoxContainer = %SwitchButtons

@onready var current_grid: PodUpgradeGrid = null


func _ready() -> void:
	var pod_setup := PlayerUtility.get_pod_setup()
	assert(pod_setup.size() > 0)
	
	var i: int = 0
	for pod_data in pod_setup:
		var pod_button := POD_BUTTON_SCENE.instantiate() as Button
		pod_button.text = pod_data.name
		pod_button.pressed.connect(set_current_grid.bind(pod_data))
		switch_buttons.add_child(pod_button)
		
		if i > 0 and i < pod_setup.size() - 1:
			var swap_button := SWAP_BUTTON_SCENE.instantiate() as Button
			swap_button.pressed.connect(swap_pods.bind(i, i + 1))
			switch_buttons.add_child(swap_button)
		
		i += 1
	
	set_current_grid(pod_setup[0])
	
	var inventory := PlayerUtility.get_inventory()
	inventory.changed.connect(_on_inventory_changed)
	update_inventory_display()


func update_inventory_display() -> void:
	var inventory := PlayerUtility.get_inventory()
	var parts: Array[String] = []
	for item: ItemData in inventory.get_items():
		parts.append(str(inventory.get_item_count(item)) + " " + item.name)
	
	if parts:
		inventory_label.text = "Inventory: " + ", ".join(parts)
	else:
		inventory_label.text = "Inventory: Empty"


func set_current_grid(pod_data: PodData) -> void:
	var new_grid := pod_data.upgrade_grid.instantiate() as PodUpgradeGrid
	new_grid.setup(pod_data)
	upgrade_grid_container.add_child(new_grid)
	
	if current_grid:
		current_grid.queue_free()
	current_grid = new_grid
	current_grid.update()
	pod_name.text = pod_data.name
	pod_description.text = pod_data.description


func swap_pods(left_pod_i: int, right_pod_i: int) -> void:
	# Have to consider the swap buttons that are between the pod buttons (after primary)
	var left_child_i := left_pod_i * 2 - 1
	var right_child_i := right_pod_i * 2 - 1
	
	var left: Button = switch_buttons.get_child(left_child_i)
	var right: Button = switch_buttons.get_child(right_child_i)
	switch_buttons.move_child(left, right_child_i)
	switch_buttons.move_child(right, left_child_i)
	
	var game := GameUtility.get_game()
	game.swap_pod_order(left_pod_i, right_pod_i)


func _on_leave_button_pressed() -> void:
	hide()
	closed.emit()


func _on_inventory_changed() -> void:
	update_inventory_display()


func _on_swap_1_pressed() -> void:
	var left: Button = switch_buttons.get_child(1)
	var right: Button = switch_buttons.get_child(3)
	switch_buttons.move_child(left, 3)
	switch_buttons.move_child(right, 1)
	
	var game := GameUtility.get_game()
	game.swap_pod_order(1, 2)


func _on_swap_2_pressed() -> void:
	var left: Button = switch_buttons.get_child(3)
	var right: Button = switch_buttons.get_child(5)
	switch_buttons.move_child(left, 5)
	switch_buttons.move_child(right, 3)
	
	var game := GameUtility.get_game()
	game.swap_pod_order(2, 3)
