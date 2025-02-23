extends PanelContainer

const Slot = preload("res://inventory/slot.tscn")

signal use_button_pressed

@onready var item_grid: GridContainer = $VBoxContainer/MarginContainer/ItemGrid

var connected = false

func set_inventory_data(inventory_data: InventoryData) -> void:
	if !connected:
		inventory_data.inventory_updated.connect(populate_item_grid)
		connected = !connected
	populate_item_grid(inventory_data)


func populate_item_grid(inventory_data: InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()
		
	for item_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if item_data:
			slot.set_slot_data(item_data)

func _on_use_button_pressed() -> void:
	#print("button")
	use_button_pressed.emit() # Replace with function body.
