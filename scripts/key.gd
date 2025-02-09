extends Node3D

@export var item_data: ItemData

func interact():
	Items.storageKey = true
	queue_free()
