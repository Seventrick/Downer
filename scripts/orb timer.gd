extends StaticBody3D
@onready var lightTimer = $LightTimer
@onready var light = $Light
@onready var orbMesh = $MeshInstance3D

var time = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if Items.timeCheck == 1 and lightTimer.is_stopped():
		#Items.timeCheck = 0
		lightTimer.start()
		
		
	#print(lightTimer.time_left)	
		
	# Orb darkening over time
	var orbOverTime = remap(lightTimer.time_left, 0, time, 0.02, 1)
	orbMesh.material_override.albedo_color = Color(orbOverTime+0.2, orbOverTime+0.07, orbOverTime+0.2, orbOverTime)
	
	# Light diminishing over time
	var continuousLight = remap(lightTimer.time_left, 0, time, 0, 3)
	light.light_energy = continuousLight
	
	

func _on_light_timer_timeout() -> void:
	pass
	print("FAE Game Of Thrones")
	
