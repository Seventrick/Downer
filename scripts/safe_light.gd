extends OmniLight3D

@onready var inbox

func _on_area_3d_body_entered(body: PhysicsBody3D) -> void:
	if body.is_in_group("player"):
		inbox = true

func _on_area_3d_body_exited(body: PhysicsBody3D) -> void:
	if body.is_in_group("player"):
		inbox = false
