extends Node2D

var style: DialogicStyle = load("res://dialogic/styles/dayStyleCustom.tres")

@onready var player: CharacterBody2D = $CharacterBody2D


func _ready() -> void:
	Crack.play()
	style.prepare()
	cutscene()
	Dialogic.signal_event.connect(_dialogicSignal)

func _dialogicSignal(argument:String):
	if argument == "bye":
		$AnimationPlayer.play("car_go")
		await get_tree().create_timer(2)
		PlayerState.movementLock = false

func cutscene():
	PlayerState.movementLock = true
	player.hide()
	$CharacterBody2D/AnimatedSprite2D.play("idle")
	$AnimationPlayer.play("car")
	
	
	#await animation end
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "car":
		await get_tree().create_timer(1)
		player.show()
		$AnimationPlayer.play("nick_walk")
		$CharacterBody2D/AnimatedSprite2D.play("run")
	if anim_name == "nick_walk":
		$CharacterBody2D/AnimatedSprite2D.play("idle")
		Dialogic.start("nick_mom")
