extends Node2D

var style: DialogicStyle = load("res://dialogic/styles/dayStyleCustom.tres")

@onready var player: CharacterBody2D = $CharacterBody2D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	style.prepare()
	cutscene()
	Dialogic.signal_event.connect(_dialogicSignal)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause_menu()
	

func toggle_pause_menu() -> void:
	if !%PauseMenu.visible:
		%PauseMenu.visible = true
		get_tree().paused = true
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$UI/PauseMenu/NinePatchRect/VBoxContainer/Continue.grab_focus()
		#%SubViewportContainer.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	else:
		%PauseMenu.visible = false
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$UI/PauseMenu/NinePatchRect/VBoxContainer/Continue.release_focus()
		#%SubViewportContainer.set_mouse_filter(Control.MOUSE_FILTER_PASS)

func _on_continue_pressed() -> void:
	toggle_pause_menu()

func _on_quit_to_desktop_pressed() -> void:
	pass
	#change for demo
	#get_tree().quit()

func _on_reset_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#%SubViewportContainer.set_mouse_filter(Control.MOUSE_FILTER_PASS)
	Crack.stop()
	#change for demo
	#get_tree().change_scene_to_file("res://scenes/main.tscn")
	get_tree().change_scene_to_file("res://scenes/main_title.tscn")


func _dialogicSignal(argument:String):
	if argument == "bye":
		$AnimationPlayer.play("car_go")
		await get_tree().create_timer(2)
		PlayerState.movementLock = false
		Crack.play()

func cutscene():
	PlayerState.movementLock = true
	player.hide()
	$CharacterBody2D/AnimatedSprite2D.play("idle")
	$AnimationPlayer.play("car")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "car":
		await get_tree().create_timer(1)
		player.show()
		$AnimationPlayer.play("nick_walk")
		$CharacterBody2D/AnimatedSprite2D.play("run")
	if anim_name == "nick_walk":
		$CharacterBody2D/AnimatedSprite2D.play("idle")
		Dialogic.start("nick_mom")
