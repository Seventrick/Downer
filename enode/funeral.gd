extends Node3D

func _ready() -> void:
	%FireSound.play()

func _process(_delta: float) -> void:
	if %FireSound.playing == false:
		%FireSound.play()
