extends Node2D

var style: DialogicStyle = load("res://dialogic/styles/dayStyleCustom.tres")

@export_file var dest_scene

@onready var player: CharacterBody2D = $CharacterBody2D
@onready var downer: Node2D = $downer

@onready var moon: PointLight2D = $PointLight2D
@onready var night: ColorRect = $CanvasLayer/ColorRect2
@onready var black: ColorRect = $CanvasLayer/ColorRect
@onready var nick_at_night: Node2D = $"nick beddy bye"

func _ready() -> void:
	style.prepare()
	nick_at_night.hide()
	night.hide()
	$CharacterBody2D/AnimatedSprite2D.play("idle")
	cutscene()
	Dialogic.signal_event.connect(_dialogicSignal)

func _dialogicSignal(argument:String):
	if argument == "turnover":
		downer.scale.x = -1
	if argument == "crip_walk":
		$CharacterBody2D/AnimatedSprite2D.play("run")
		$AnimationPlayer.play("waltz_away")
	if argument == "stir":
		nick_at_night.scale.x = 1
	if argument == "doze":
		$AnimationPlayer.play("doze")
	if argument == "eep":
		$AnimationPlayer.play("eep")
	if argument == "next":
		PlayerState.movementLock = false
		get_tree().change_scene_to_file(dest_scene)

func cutscene():
	PlayerState.movementLock = true
	$AnimationPlayer.play("waltz")
	$CharacterBody2D/AnimatedSprite2D.play("run")
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "waltz":
		$CharacterBody2D/AnimatedSprite2D.play("idle")
		await get_tree().create_timer(1)
		Dialogic.start("downerIntro")
	if anim_name == "waltz_away":
		$CharacterBody2D/AnimatedSprite2D.play("idle")
		await get_tree().create_timer(2)
		$AnimationPlayer.play("fade_out")
	if anim_name == "fade_out":
		night.show()
		Crack.stop()
		player.hide()
		nick_at_night.show()
		$AnimationPlayer.play("fade_in")
	if anim_name == "fade_in":
		Dialogic.start("nightTime")
