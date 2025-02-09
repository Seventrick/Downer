extends StaticBody3D

var resource = load("res://dialogue/main.dialogue")

func interact():
	DialogueManager.show_dialogue_balloon(resource, "oh_test_oh_gummy_bear")
