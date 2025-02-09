extends Control

var grabbed_item_data: ItemData
var grabbed_collectible_data: ItemData

@onready var player_inventory: PanelContainer = $NinePatchRect/VBoxContainer/Control/PlayerInventory
@onready var collectible_inventory: PanelContainer = $NinePatchRect/VBoxContainer/Control/CollectibleInventory
@onready var item_name: RichTextLabel = $NinePatchRect/VBoxContainer/Control/PlayerInventory/VBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Name
@onready var description: RichTextLabel = $NinePatchRect/VBoxContainer/Control/PlayerInventory/VBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Description
@onready var collectible_name: RichTextLabel = $NinePatchRect/VBoxContainer/Control/CollectibleInventory/VBoxContainer/Panel/MarginContainer/VBoxContainer/Name
@onready var collectible_description: RichTextLabel = $NinePatchRect/VBoxContainer/Control/CollectibleInventory/VBoxContainer/Panel/MarginContainer/VBoxContainer/Description


func _ready() -> void:
	player_inventory.use_button_pressed.connect(on_use_button_pressed)

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)

func set_collectible_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_collectible_inventory_interact)
	collectible_inventory.set_inventory_data(inventory_data)

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	#print("%s %s %s"  % [inventory_data, index, button])#
	
	if button == MOUSE_BUTTON_LEFT:
		grabbed_item_data = inventory_data.grab_item_data(index)
		#grabbed_collectible_data = inventory_data.grab_collectible_data(index)
	update_item_data()
	#print(grabbed_collectible_data)
	print(grabbed_item_data)

func on_collectible_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	if button == MOUSE_BUTTON_LEFT:
		#grabbed_item_data = inventory_data.grab_item_data(index)
		grabbed_collectible_data = inventory_data.grab_collectible_data(index)
	update_item_data()
	print(grabbed_collectible_data)
	#print(grabbed_item_data)

func update_item_data() -> void:
	if grabbed_item_data:
		item_name.text = grabbed_item_data.name
		description.text = grabbed_item_data.description
	else:
		item_name.text = ""
		description.text = ""

#func update_collectible_item_data() -> void:
	if grabbed_collectible_data:
		collectible_name.text = grabbed_collectible_data.name
		collectible_description.text = grabbed_collectible_data.description
	else:
		collectible_name.text = ""
		collectible_description.text = ""

func on_use_button_pressed() -> void:
	if grabbed_item_data != null:
		#print(item_name.text + " used")
		grabbed_item_data.use()
		
