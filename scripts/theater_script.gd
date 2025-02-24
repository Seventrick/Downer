extends StaticBody3D

@export var item_data: ItemData
@onready var report_light: GPUParticles3D = $"../lights/reportLight"

func interact():
	report_light.show()
	
