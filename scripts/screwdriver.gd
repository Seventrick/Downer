extends StaticBody3D

@export var item_data: ItemData

func interact():
	Items.screwdriver = true
	print("picked up screwdriver")
