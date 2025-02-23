extends StaticBody3D

@onready var outer_sphere: MeshInstance3D = $"Outer Sphere"
@onready var inner_sphere: MeshInstance3D = $"Inner Sphere"

@export var item_data: ItemData
@onready var essence: StaticBody3D = $"."


func _ready() -> void:
	#essence.item_data.item_used.connect(item_was_used)
	pass

func item_was_used():
	#Items.essenceUsed = true
	#Items.essenceUsed = false
	pass


func _process(_delta: float) -> void:
	
	#Items.essenceUsed = true
	#Items.essenceUsed = false
	
	pass
