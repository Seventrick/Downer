extends AnimatableBody3D

@onready var resource = load("res://dialogue/mommy.dialogue")
@export var balloon: PackedScene

func interact():
	if !PlayerState.momChat:
		DialogueManager.show_dialogue_balloon_scene(balloon, resource, "chatWithMom")
