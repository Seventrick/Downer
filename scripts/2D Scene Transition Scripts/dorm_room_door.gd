extends Area2D

@export_file var dest_scene
@onready var door: AudioStreamPlayer = $AudioStreamPlayer

var entered = false

func _ready() -> void:
	door.play()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		entered = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		entered = false


func _process(delta: float) -> void:
	if entered == true:
		if Input.is_action_just_pressed("interact"):
			get_tree().change_scene_to_file(dest_scene)
