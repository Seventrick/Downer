extends StaticBody3D

@onready var resource = load("res://dialogue/friend.dialogue")
@export var balloon: PackedScene

func recharge():
	if !PlayerState.birdTalked1 and !PlayerState.OPENBOX:
		DialogueManager.show_dialogue_balloon_scene(balloon, resource, "chatFirst")
	Items.timeCheck = 1
