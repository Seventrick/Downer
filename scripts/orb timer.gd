extends StaticBody3D

@onready var lightTimer = $LightTimer
@onready var light = $Light
@onready var orbMesh = $MeshInstance3D

@onready var essence: StaticBody3D = $StaticBody3D


var time = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	essence.item_data.item_used.connect(item_was_used)
	
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
	
	

func item_was_used():
	print("used")
	
	#lightTimer.set_wait_time(boost)
	lightTimer.set_paused(true)
	var boost = lightTimer.get_wait_time()
	boost += 6 #number of seconds that the essence gives
	lightTimer.start(boost)
	lightTimer.set_paused(false) 
	
	#essence.item_data.use_up()


func _on_light_timer_timeout() -> void:
	pass
	print("FAE Game Of Thrones")
	
