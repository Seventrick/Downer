extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

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
	Crack.stop()
	#%SubViewportContainer.set_mouse_filter(Control.MOUSE_FILTER_PASS)
	
	#change for demo
	#get_tree().change_scene_to_file("res://scenes/main.tscn")
	get_tree().change_scene_to_file("res://scenes/main_title.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
