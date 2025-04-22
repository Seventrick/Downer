extends Control


func _ready() -> void:
	$NinePatchRect/Start.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_start_pressed() -> void:
	
	$AnimationPlayer.play("start_pressed")



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start_pressed":
		
		$VideoStreamPlayer.play()
		$AnimationPlayer.play("cutscene")
	if anim_name == "fade":
		get_tree().change_scene_to_file("res://scenes/2d_main.tscn")


func _on_video_stream_player_finished() -> void:
	$AnimationPlayer.play("fade")


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()
