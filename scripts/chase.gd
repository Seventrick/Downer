extends Node3D

#@onready var nextScene = "res://scenes/mothers_house.tscn"

@onready var resource = load("res://dialogue/chase.dialogue")
@export var balloon: PackedScene

@onready var downerResource = load("res://dialogue/downer.dialogue")
@export var downerBalloon: PackedScene

#@onready var SeeCast: RayCast3D = $SubViewportContainer/SubViewport/Player/Head/Camera3D/SeeCast
#@onready var reticle: Sprite2D = $reticle
#@onready var red_reticle: Sprite2D = $redReticle
@onready var path_follow: PathFollow3D = $Path3D/PathFollow3D
@onready var playerCam = get_parent().get_parent().get_node("Player").get_node("Head").get_node("Camera3D")
@onready var player_zone: ShapeCast3D = get_parent().get_parent().get_node("Player").get_node("PlayerZone")
@onready var head: Node3D = get_parent().get_parent().get_node("Player").get_node("Head")
@onready var janston: StaticBody3D = $janstonHold
@onready var audienceHold: StaticBody3D = $audienceHold
@onready var player: CharacterBody3D = get_parent().get_parent().get_node("Player")
@onready var markerA = $MarkerA.global_position


#tracks which line to display
var dialogue = 1

func _ready() -> void:
	$Path3D/PathFollow3D/PreMonster/Area3D/CollisionShape3D.set_disabled(true)
	DialogueManager.show_dialogue_balloon_scene(downerBalloon, downerResource, "first")
	$Path3D/PathFollow3D/PreMonster/AnimationPlayer.play("run", -1, 1.5)

func _physics_process(delta):
	if !PlayerState.chase:
		path_follow.progress += 7 * delta

	"""if SeeCast.is_colliding():
		var target = SeeCast.get_collider()
		if target != null and target.is_in_group("interactable"):
			red_reticle.show()
			reticle.hide()
	else:
		red_reticle.hide()
		reticle.show()"""
	
	#look at janston
	if PlayerState.janstonTime:
		head.look_at(janston.global_position, Vector3.UP)
	
	#look at audience
	if PlayerState.audienceTime:
		head.look_at(audienceHold.global_position, Vector3.UP)
	
	if PlayerState.backAway:
		player.global_position = player.global_position.move_toward(markerA, delta * 6)
	
	# detect area
	if player_zone.is_colliding():
		var target = player_zone.get_collider(0)
		#print(target)
		if target != null and target.is_in_group("detectables"):
			#getJumped()
			pass


func sceneChange():
	pass

func beginChase():
	#PlayerState.chase = true
	$Path3D/PathFollow3D/PreMonster/Area3D/CollisionShape3D.set_disabled(false)
	$Path3D.show()
	

#jumpscares player and changes scene
func getJumped():
	switchCam()
	await get_tree().create_timer(2.0).timeout
	switchCamBack()
	sceneChange()

#switch to jumpscare cam
func switchCam():
	%monsterCamera.make_current()
	playerCam.clear_current()

func switchCamBack():
	playerCam.make_current()
	%monsterCamera.clear_current()

#if a dialogue ballon is open, close it
func checkDialogue():
	if get_parent().get_parent().get_node("ExampleBalloon") != null:
		get_parent().get_parent().get_node("ExampleBalloon").queue_free()

#puts dogs on stage and activates light for "downer's spot"
func readyStage():
	print("stage readied")
	$SpotOnStage/SpotLight3D4.show()
	$janstonHold.show()
	$janstonHold/CollisionShape3D.set_disabled(false)

#activates janston's transformation sequence
func janstonTransformationStart():
	print("janston is transforming D: D: D:")
	pass

#player jumps off stage
func runOffStage():
	print("jump'n'go")
	pass

#starts the chase and yes, the monster will in fact always eat the player, and no, it is not considered vore because it was not cool bro
func startChase():
	print("chase began")
	pass

#janston fully transforms
func janstonTransformation():
	print("janston transformed")
	pass

#region Dialogue Triggers

func _on_dialogue_line_2_body_entered(body: PhysicsBody3D) -> void:
	if dialogue <= 1 and body.is_in_group("player"):
		dialogue += 1
		checkDialogue()
		DialogueManager.show_dialogue_balloon_scene(downerBalloon, downerResource, "second")


func _on_dialogue_line_3_body_entered(body: PhysicsBody3D) -> void:
	if dialogue <= 2 and body.is_in_group("player"):
		dialogue += 1
		checkDialogue()
		DialogueManager.show_dialogue_balloon_scene(downerBalloon, downerResource, "third")


func _on_dialogue_line_4_body_entered(body: PhysicsBody3D) -> void:
	if dialogue <= 3 and body.is_in_group("player"):
		dialogue += 1
		checkDialogue()
		DialogueManager.show_dialogue_balloon_scene(downerBalloon, downerResource, "fourth")

func _on_mask_dialogue_body_entered(body: PhysicsBody3D) -> void:
	if dialogue <= 4 and body.is_in_group("player"):
		dialogue += 1
		checkDialogue()
		DialogueManager.show_dialogue_balloon_scene(balloon, resource, "studentOffStage")

func _on_spot_on_stage_body_entered(_body: PhysicsBody3D) -> void:
	if PlayerState.lineReady:
		DialogueManager.show_dialogue_balloon_scene(balloon, resource, "teacher")
		await get_tree().create_timer(6).timeout
		checkDialogue()
		DialogueManager.show_dialogue_balloon_scene(downerBalloon, downerResource, "janstonScene")
		PlayerState.lineReady = false

func _on_ceiling_cave_area_body_entered(body: PhysicsBody3D) -> void:
	if body.is_in_group("player"):
		print("locker")

#endregion
