extends Node3D

@export var assetData: SuperpositionAssetData

#is the player within range of the "change asset" area
@onready var changeable = false

#is the player within the range of the "do not change asset" area
@onready var safe = true

@onready var timer: Timer = $SuperpositionTimer

@onready var asset

func _ready() -> void:
	assetPicker()
	checkAreas()


func checkAreas() -> void:
	if changeable and !safe:
		timer.start()
	# if areas return true then nono do thing then check again



#add weight to the outcome of the asset
func assetPicker() -> void:
	
	var picker = round(randf_range(1, 3))
	
	if get_child(-1) != $SuperpositionTimer:
			get_child(-1).queue_free()
	
	if picker == 1:
		asset = assetData.asset1.instantiate()
		add_child(asset)
	elif picker == 2:
		asset = assetData.asset2.instantiate()
		add_child(asset)
	elif picker == 3:
		asset = assetData.asset3.instantiate()
		add_child(asset)
	
	print(picker)


#timer runs every second the player is in the change area
#object only changes when the player is within change and outside safe
#this can prevent lag and allow for enough time to change before light hits the object


func change_entered(area: Area3D) -> void:
	if area.is_in_group("lightSources"):
		changeable = true
		checkAreas()


func change_exited(area: Area3D) -> void:
	if area.is_in_group("lightSources"):
		changeable = false
		timer.stop()


func safe_entered(area: Area3D) -> void:
	if area.is_in_group("lightSources"):
		safe = true


func safe_exited(area: Area3D) -> void:
	if area.is_in_group("lightSources"):
		safe = false
		checkAreas()


func _on_superposition_timer_timeout() -> void:
	if !safe:
		assetPicker()
