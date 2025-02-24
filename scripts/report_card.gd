extends StaticBody3D

@export var item_data: ItemData

@onready var orb_light: GPUParticles3D = $"../lights/orbLight"
@onready var orb_light_2: GPUParticles3D = $"../lights/orbLight2"


func interact():
	orb_light.show()
	orb_light_2.show()
