extends Node3D

# Called when the node enters the scene tree for the first time.
func wall_break():
	%wall.hide()
	%window.show()
	print("broken!")

func _on_wall_break_area_entered(_area: Area3D) -> void:
	wall_break()
