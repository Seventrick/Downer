extends Node3D

@export var level_data: LevelData

func _on_area_3d_body_entered_door1(_body: CharacterBody3D) -> void:
	get_parent().summon_level("test_2")


func _on_area_3d_body_entered_door2(_body: CharacterBody3D) -> void:
	get_parent().enode_calc("High School")
