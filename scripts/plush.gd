extends StaticBody3D

@export var item_data: ItemData

@onready var omni_light_3d: OmniLight3D = $"../OmniLight3D"

func interact():
	
	omni_light_3d.show()
