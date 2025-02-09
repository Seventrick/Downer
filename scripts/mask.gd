extends StaticBody3D

@onready var resource = load("res://dialogue/downer.dialogue")
@export var balloon: PackedScene

func interact():
	if !Items.mask:
		Items.mask = true
		DialogueManager.show_dialogue_balloon_scene(balloon, resource, "fifth")
		queue_free()
