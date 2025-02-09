extends StaticBody3D

@onready var lightCollision: CollisionShape3D = $"Light/safe zone/CollisionShape3D"


func _on_timer_timeout() -> void:
	
	if %Light.visible == true:
		%Light.hide()
		lightCollision.set_disabled(true)
	else:
		%Light.show()
		lightCollision.set_disabled(false)
