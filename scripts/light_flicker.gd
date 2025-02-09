extends OmniLight3D


func _ready() -> void:
	toggle()

func toggle():
	await get_tree().create_timer(randf_range(1, 4)).timeout
	if $".".visible:
		$".".hide()
		await get_tree().create_timer(0.06).timeout
		$".".show()
		await get_tree().create_timer(0.04).timeout
		$".".hide()
		await get_tree().create_timer(0.04).timeout
		$".".show()
		await get_tree().create_timer(0.06).timeout
		$".".hide()
		get_parent().global_position.y += 1
	else:
		$".".show()
		get_parent().global_position.y -= 1
	toggle()



"""
func flicker_out():
	pick number 1-3
	that is how many times it flickers
	adjust light energy (decelerate it)
	random number of flicker time

same for flicker in but reverse

"""
