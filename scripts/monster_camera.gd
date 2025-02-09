extends Camera3D









"""var intensity = 1
var duration = 1
var startTime = 0
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	randomize()
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var decreaser = (duration - (Time.get_ticks_msec() - startTime)) / duration
	
	var randX = rng.randf_range(-1,1) * intensity * decreaser
	var randY = rng.randf_range(-1,1) * intensity * decreaser
	
	h_offset = randX
	v_offset = randY
	
	if decreaser < 0:
		h_offset = 0
		v_offset = 0
		set_process(false)
	cameraShake()
func cameraShake(intensity = 1.0, duration = 1.0):
	intensity = float(intensity)
	duration = float(duration * 1000)
	startTime = Time.get_ticks_msec()
	
	set_process(true)"""
	
