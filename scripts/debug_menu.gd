extends Control








func go_to_level(level) -> void:
	get_parent().enode.summon_level(level)


func _location1_pressed() -> void:
	get_parent().enode.summon_level("forest_test")


func _location2_pressed() -> void:
	get_parent().enode.summon_level("puzzle_level")


func _location3_pressed() -> void:
	get_parent().enode.summon_level("mothers_house")


func _location4_pressed() -> void:
	get_parent().enode.summon_level("quantum_room")


func _location5_pressed() -> void:
	get_parent().enode.summon_level("quantum_room")


func _custom_location_submitted(new_text: String) -> void:
	go_to_level(new_text)
