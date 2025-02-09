extends OmniLight3D

@export var noise: NoiseTexture3D
var time_passed := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	#print(time_passed)
	
	var sampled_noise = noise.noise.get_noise_1d(time_passed * 2)
	var new_sampled_noise = remap(sampled_noise, -0.3, 0.3, 9, 12)
	
	light_energy = new_sampled_noise
	#print(new_sampled_noise)
	#print(sampled_noise)

	pass
