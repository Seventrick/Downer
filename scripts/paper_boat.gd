extends StaticBody3D

@export var item_data: ItemData
@onready var boat_light: GPUParticles3D = $"../lights/boatLight"

func interact():
	boat_light.show()
