extends Node2D

var style: DialogicStyle = load("res://dialogic/styles/dayStyleCustom.tres")
var cooldown = false
@onready var timer: Timer = $Timer

var entered = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	style.prepare()
	Dialogic.signal_event.connect(_dialogicTimer)

func _dialogicTimer(argument:String):
	if argument == "dialogicTimer":
		PlayerState.movementLock = false
		timer.start()
		cooldown = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if entered:
		if Input.is_action_just_pressed("interact"):
			if Dialogic.current_timeline == null and !cooldown:
				Dialogic.start("athletic_dude")
				PlayerState.movementLock = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		entered = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		entered = false


func _on_timer_timeout() -> void:
	cooldown = false
