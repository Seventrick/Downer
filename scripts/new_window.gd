extends StaticBody3D

#var colliding = false

@onready var screwdriver: StaticBody3D = $"../screwdriver"


@onready var resource = load("res://dialogue/friend.dialogue")
@export var balloon: PackedScene

func _ready() -> void:
	screwdriver.item_data.item_used.connect(item_was_used)
	#player.colliding_with_interactable.connect(_colliding)
	#player.not_colliding.connect(_not_colliding)

func interact():
	if !PlayerState.window and !PlayerState.OPENBOX:
		DialogueManager.show_dialogue_balloon_scene(balloon, resource, "window_closed")
	if PlayerState.window and !PlayerState.OPENBOX:
		DialogueManager.show_dialogue_balloon_scene(balloon, resource, "window_open")

func item_was_used() -> void:
	if PlayerState.colliding_with_interactable == true:
		$window2.hide() #i want the window animation here
		PlayerState.item_used_succesfully = true
		if !PlayerState.window:
			DialogueManager.show_dialogue_balloon_scene(balloon, resource, "window")
		
"""func _colliding() -> void:
	colliding = true
	
func _not_colliding() -> void:
	colliding = false
"""
