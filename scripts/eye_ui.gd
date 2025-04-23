extends Node2D

@onready var safeBar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	safeBar.value = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	# death
	if safeBar.value <= 0:
		PlayerState.dead = true
	
	# screen darkening
	
	if safeBar.value > 50:
		%SleepScreen.color = Color (0, 0, 0, 0)
	else:
		var darkness = remap(safeBar.value, 0, 50, 1, 0)
		%SleepScreen.color = Color (0, 0, 0, darkness)
	
	# progress bar increasing
		
	if PlayerState.safe == true:
		safeBar.value += 0.50 * delta
	else:
		safeBar.value -= 0.25 * delta

	
	# eye UI
	
	if safeBar.value >= 0 and safeBar.value < 14:
		$eye7.show()
		$eye6.hide()
		$eye5.hide()
		$eye4.hide()
		$eye3.hide()
		$eye2.hide()
		$eye1.hide()
	elif safeBar.value >= 14 and safeBar.value < 28:
		$eye7.hide()
		$eye6.show()
		$eye5.hide()
		$eye4.hide()
		$eye3.hide()
		$eye2.hide()
		$eye1.hide()
	elif safeBar.value >= 28 and safeBar.value < 42:
		$eye7.hide()
		$eye6.hide()
		$eye5.show()
		$eye4.hide()
		$eye3.hide()
		$eye2.hide()
		$eye1.hide()
	elif safeBar.value >= 42 and safeBar.value < 56:
		$eye7.hide()
		$eye6.hide()
		$eye5.hide()
		$eye4.show()
		$eye3.hide()
		$eye2.hide()
		$eye1.hide()
	elif safeBar.value >= 56 and safeBar.value <  70:
		$eye7.hide()
		$eye6.hide()
		$eye5.hide()
		$eye4.hide()
		$eye3.show()
		$eye2.hide()
		$eye1.hide()
	elif safeBar.value >= 70 and safeBar.value <  84:
		$eye7.hide()
		$eye6.hide()
		$eye5.hide()
		$eye4.hide()
		$eye3.hide()
		$eye2.show()
		$eye1.hide()
	else:
		$eye7.hide()
		$eye6.hide()
		$eye5.hide()
		$eye4.hide()
		$eye3.hide()
		$eye2.hide()
		$eye1.show()
	
