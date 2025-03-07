extends Node3D

@export var assetData: SuperpositionAssetData

func _ready() -> void:
	var asset
	assetPicker()

func assetPicker() -> void:
	
	var picker = round(randf_range(1, 3))
	
	if picker == 1:
		pass
	elif picker == 2:
		pass
	elif picker == 3:
		pass
	
	print(picker)


#timer runs every second the player is in the change area
#object only changes when the player is within change and outside safe
#this can prevent lag and allow for enough time to change before light hits the object
