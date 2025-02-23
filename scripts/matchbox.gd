extends StaticBody3D

@export var item_data: ItemData

@onready var matchbox: StaticBody3D = $"."

func _ready() -> void:
	matchbox.item_data.item_used.connect(item_was_used)


func item_was_used():
	print("used")
