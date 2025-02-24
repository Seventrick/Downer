extends StaticBody3D

@export var item_data: ItemData

@onready var bear_light_1: GPUParticles3D = $"../lights/bearLight1"
@onready var bear_light_2: GPUParticles3D = $"../lights/bearLight2"


func interact():
	
	bear_light_1.show()
	bear_light_2.show()
