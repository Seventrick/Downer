extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

@export var slot_datas: Array[ItemData]

func grab_item_data(index: int) -> ItemData:
	var item_data = slot_datas[index]

	if item_data:
		return item_data
	else:
		return null

func pickup_item_data(item_data: ItemData) -> bool:
	for index in slot_datas.size():
		if not slot_datas[index]:
			slot_datas[index] = item_data
			inventory_updated.emit(self)
			return true
	return false

func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)
	
	#print(slot_datas)
