extends MeshInstance3D

var timer = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer:
		position.z += 0.1
	else:
		position.z -= 0.1

func _on_timer_timeout() -> void:
	timer = !timer
