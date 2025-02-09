extends RigidBody3D

@onready var box = $"."
@onready var coyote_time: Timer = $coyoteTime

#region new
@onready var marker: Marker3D = $"../fireworkMarker"

@onready var matchbox: StaticBody3D = $"../matchbox"

@onready var resource = load("res://dialogue/friend.dialogue")
@export var balloon: PackedScene

#endregion

var startPos
var boxed = false
var coyote = false

func _ready() -> void:
	matchbox.item_data.item_used.connect(item_was_used)
	startPos = box.global_position

func interact():
	pass
		#use this to initiate bars being destroyed

func item_was_used() -> void:
	if PlayerState.colliding_with_interactable == true:
		
		if boxed and !PlayerState.OPENBOX:
			DialogueManager.show_dialogue_balloon_scene(balloon, resource, "firework_box_ready")
			PlayerState.item_used_succesfully = true
		else:
			if !PlayerState.OPENBOX:
				DialogueManager.show_dialogue_balloon_scene(balloon, resource, "firework_box_not_ready")
				PlayerState.item_used_succesfully = true

func ending() -> void:
	PlayerState.safe = true
	get_parent().get_parent().get_parent().get_parent().get_parent().changeThing()
	$"../fireworks".play()
	get_parent().get_parent().get_parent().get_parent().get_parent().get_node("AnimationPlayer").play("end")


func _physics_process(_delta: float) -> void:
	if %BoxZone.is_colliding():
		var target = %BoxZone.get_collider(0)
		#print(target)
		if target != null and target.is_in_group("lightSources"):
			coyote_time.stop()
			coyote = false
	elif not %BoxZone.is_colliding() and coyote == false:
		coyote = !coyote
		coyote_time.start()

	if %WindowZone.is_colliding():
		var target = %WindowZone.get_collider(0)
		if target != null and target.is_in_group("window"): #disables movement once the box is near the window
			boxed = true
	
	if boxed:
		global_position = marker.global_position


func _on_coyote_time_timeout() -> void:
	box.set_global_position(startPos)
	coyote = false
