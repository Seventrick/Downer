extends InventoryData
class_name CollectibleInventoryData

func grab_collectible_data(index: int) -> ItemData:
	var item_data = slot_datas[index]

	if item_data:
		return item_data
	else:
		return null
