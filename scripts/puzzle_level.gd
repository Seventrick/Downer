extends Node3D


@onready var bird: StaticBody3D = $Recharge
@onready var bird_flying: Node3D = $"bird&all/birdFlying"

@onready var orb_pickup: StaticBody3D = $OrbPickup
@onready var orb_fall: StaticBody3D = $"bird&all/OrbPickup2"

@onready var resource = load("res://dialogue/friend.dialogue")
@export var balloon: PackedScene

"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerState.controlLock = true
	get_parent().get_parent().get_node("Player").get_node("Head").look_at(bird.global_position, Vector3.UP)
	DialogueManager.show_dialogue_balloon_scene(balloon, resource, "intro")

func introScene() -> void:
	$AnimationPlayer.play("intro")
	await $AnimationPlayer.animation_finished
	orb_fall.queue_free()
	PlayerState.controlLock = false
"""
