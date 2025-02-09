extends Node3D

@onready var nextScene = "res://scenes/level.tscn"

@onready var resource = load("res://dialogue/chase.dialogue")
@export var balloon: PackedScene

@onready var bird = $SubViewportContainer/SubViewport/blockbench_export
@onready var monster = $SubViewportContainer/SubViewport/PreMonster
@onready var player = $SubViewportContainer/SubViewport/Player
@onready var head = $SubViewportContainer/SubViewport/Player/Head
@onready var markerA = $markerDoor.global_position
@onready var markerAUp = $markerDoorUp.global_position
@onready var markerB = $markerRoom.global_position
@onready var markerBUp = $markerRoomUp.global_position


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	saveCutscene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlayerState.flyingSave and !PlayerState.kidnapped:
		bird.global_position = bird.global_position.move_toward(markerAUp, delta * 6)
		head.look_at(bird.global_position, Vector3.UP)
	if !PlayerState.flyingSave and !PlayerState.kidnapped and !PlayerState.enterRoom:
		head.look_at(monster.global_position, Vector3.UP)
	if PlayerState.kidnapped:
		player.global_position = player.global_position.move_toward(markerA, delta * 6)
		bird.global_position = bird.global_position.move_toward(markerAUp, delta * 6)
	if PlayerState.enterRoom:
		player.global_position = player.global_position.move_toward(markerB, delta * 6)
		bird.global_position = bird.global_position.move_toward(markerBUp, delta * 6)

func saveCutscene():
	DialogueManager.show_dialogue_balloon_scene(balloon, resource, "saveCutscene")

func sceneChange():
	get_tree().change_scene_to_file(nextScene)

func rotateThem():
	player.rotate(Vector3(0,1,0), deg_to_rad(-90))
	bird.rotate(Vector3(0,1,0), deg_to_rad(-90))
	pass
	
