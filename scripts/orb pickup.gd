extends StaticBody3D

@export var item_data: ItemData

func orb_pickup():
	print("You interacted!")
	queue_free()
	
