extends Node3D

#region New for main node

@export var save_data: SaveData
@onready var save_path = "user://save_data.tres"

@onready var player: CharacterBody3D = $SubViewportContainer/SubViewport/Player
@onready var enode: Node = $SubViewportContainer/SubViewport/ENOde

@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var player_inventory: PanelContainer = $UI/InventoryInterface/NinePatchRect/VBoxContainer/Control/PlayerInventory
@onready var collectible_inventory: PanelContainer = $UI/InventoryInterface/NinePatchRect/VBoxContainer/Control/CollectibleInventory


@onready var reticleCheck = false

@export var debug_menu_scene: PackedScene
@onready var debugVar = false

#endregion



@onready var SeeCast = $SubViewportContainer/SubViewport/Player/Head/Camera3D/SeeCast
@onready var safeBar: ProgressBar = $UI/EyeUI/ProgressBar
@onready var boxCooldown: Timer = $SubViewportContainer/SubViewport/Player/boxCooldown
@onready var red_reticle: Sprite2D = $UI/redReticle
@onready var reticle: Sprite2D = $UI/reticle
@onready var head = $SubViewportContainer/SubViewport/Player/Head
#@onready var orbPickup = $SubViewportContainer/SubViewport/OrbPickup
@onready var rechargeBar = $UI/rechargeBar


@onready var resource = load("res://dialogue/friend.dialogue")
@export var balloon: PackedScene

@onready var color_rect_2: ColorRect = $UI/ColorRect2

@onready var cursor = load("res://assets/2D assets/ccursor1.png")
@onready var cursorPoint = load("res://assets/2D assets/ccursor2.png")

@onready var curMouse = false

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	
	player.toggle_inventory.connect(toggle_inventory_interface)
	
	Input.set_custom_mouse_cursor(cursor, 0, Vector2(40, 40))
	Input.set_custom_mouse_cursor(cursorPoint, Input.CURSOR_POINTING_HAND, Vector2(40, 40))
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_CROSS, Vector2(40, 40))
	
	#demoIntro()
	#print(color_rect_2.material.shader.shader_parameter)
	#color_rect_2.set("shader_paramater/interference_amount", 1.0)
	load_game()
	#changeThing()

func _process(delta):
	
	if PlayerState.dead == true:
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		#get_tree().quit()
		player.position = Vector3(0, 1, 0)
		Items.useOrb = 0 # check if orb exists first
		$SubViewportContainer/SubViewport/Player/Head/Camera3D/Orb.hide()
		$"SubViewportContainer/SubViewport/Player/Head/Camera3D/Orb/safe zone/CollisionShape3D".set_disabled(true)
		Items.timeCheck = 1
		PlayerState.dead = false
		
	
	if boxCooldown.is_stopped() == false:
		rechargeBar.show()
		rechargeBar.value = remap(boxCooldown.time_left, 0, 0.3, 0, 100)
	else:
		rechargeBar.hide()
	
	
	if InputEventJoypadMotion and curMouse:
		if abs(x_axis) > 0.09 or abs(y_axis) > 0.09:
			var mouse_pos = get_viewport().get_mouse_position()
			var new_mouse_pos = mouse_pos + Vector2(x_axis, y_axis) * conCursorSens * delta
			Input.warp_mouse(new_mouse_pos)
	
	

func _physics_process(_delta: float) -> void:
	
	if SeeCast.is_colliding() and reticleCheck:
		var target = SeeCast.get_collider()
		if target != null and target.is_in_group("interactable"):
			red_reticle.show()
			reticle.hide()
	elif reticleCheck:
		red_reticle.hide()
		reticle.show()
	print(x_axis)
	print(y_axis)
	

func _unhandled_input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("inventory") and !%PauseMenu.visible:
		toggle_inventory_interface()
	
	#I want this button to work while paused :(
	if Input.is_action_just_pressed("pause") and !inventory_interface.visible:
		toggle_pause_menu()
	
	if Input.is_action_just_pressed("interact") and curMouse:
		click()
	
	#meant for testing
	if Input.is_action_pressed("dud"):
		save_game()
	if Input.is_action_pressed("dud"):
		load_game()
	if Input.is_action_pressed("debug"):
		debug()


var conCursorSens: float = 700.0
var x_axis: float = 0.0
var y_axis: float = 0.0

func _input(event: InputEvent) -> void:
		if event is InputEventJoypadMotion and curMouse:
			if event.axis == 0:
				x_axis = event.axis_value
			if event.axis == 1:
				y_axis = event.axis_value

func click():
	var a = InputEventMouseButton.new()
	a.position = get_viewport().get_mouse_position()
	a.button_index = MOUSE_BUTTON_LEFT
	a.pressed = true
	Input.parse_input_event(a)
	await get_tree().process_frame
	a.pressed = false
	Input.parse_input_event(a)


func debug() -> void:
	
	if !debugVar:
		var debug_menu = debug_menu_scene.instantiate()
		add_child(debug_menu)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		%SubViewportContainer.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
		debugVar = true
	elif debugVar:
		get_child(-1).queue_free()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		%SubViewportContainer.set_mouse_filter(Control.MOUSE_FILTER_PASS)
		debugVar = false
		#changing scene can cause another thing to come up therefore being what is closed


func demoIntro() -> void:
	PlayerState.controlLock = true
	$UI/ColorRect2.hide()
	$UI/black2.show()
	await get_tree().create_timer(3).timeout
	$UI/controls.show()
	$UI/black2.hide()
	await get_tree().create_timer(5).timeout
	$UI/controls.hide()
	$UI/VideoStreamPlayer.show()
	$UI/VideoStreamPlayer.play()
	
	await get_tree().create_timer(5).timeout
	$AnimationPlayer.play("end")
	await get_tree().create_timer(4).timeout
	$UI/VideoStreamPlayer.hide()
	load_game()
	await get_tree().create_timer(2).timeout
	$UI/blackMain.hide()
	$UI/ColorRect2.show()
	reticleCheck = true
	$UI/EyeUI.show()
	PlayerState.controlLock = false

func changeThing() -> void:
	
	$UI/EyeUI.hide()
	reticleCheck = false
	red_reticle.hide()
	reticle.hide()

#region Inventory

func toggle_inventory_interface() -> void:
	inventory_interface.visible = not inventory_interface.visible
	#player_inventory.visible = not player_inventory.visible
	
	if inventory_interface.visible:
		PlayerState.controlLock = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		curMouse = true
		x_axis = 0.0
		y_axis = 0.0
		#$UI/InventoryInterface/NinePatchRect/VBoxContainer/Control/PlayerInventory/VBoxContainer/MarginContainer/ItemGrid/Slot/Button.grab_focus()
		%SubViewportContainer.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	else:
		PlayerState.controlLock =  false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		curMouse = false
		#$UI/InventoryInterface/NinePatchRect/VBoxContainer/Control/PlayerInventory/VBoxContainer/MarginContainer/ItemGrid/Slot/Button.release_focus()
		%SubViewportContainer.set_mouse_filter(Control.MOUSE_FILTER_PASS)

func _on_items_pressed() -> void:
	collectible_inventory.hide()
	player_inventory.show()
	%Items.button_pressed = true
	%Collectibles.button_pressed = false


func _on_collectibles_pressed() -> void:
	player_inventory.hide()
	collectible_inventory.show()
	%Items.button_pressed = false
	%Collectibles.button_pressed = true

#endregion


#region Pause Menu

func toggle_pause_menu() -> void:
	if !%PauseMenu.visible:
		%PauseMenu.visible = true
		get_tree().paused = true
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$UI/PauseMenu/NinePatchRect/VBoxContainer/Continue.grab_focus()
		%SubViewportContainer.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	else:
		%PauseMenu.visible = false
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$UI/PauseMenu/NinePatchRect/VBoxContainer/Continue.release_focus()
		%SubViewportContainer.set_mouse_filter(Control.MOUSE_FILTER_PASS)

func _on_continue_pressed() -> void:
	toggle_pause_menu()

func _on_quit_to_desktop_pressed() -> void:
	pass
	#change for demo
	#get_tree().quit()

func _on_reset_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	%SubViewportContainer.set_mouse_filter(Control.MOUSE_FILTER_PASS)
	
	#change for demo
	#get_tree().change_scene_to_file("res://scenes/main.tscn")
	get_tree().change_scene_to_file("res://scenes/main_title.tscn")
	
#endregion


#region Save/Load

func save_game() -> void:
	updateSaveData()
	ResourceSaver.save(save_data, save_path)

func load_game() -> void:
	if ResourceLoader.exists(save_path):
		save_data = ResourceLoader.load(save_path, "", ResourceLoader.CACHE_MODE_IGNORE)
		updateData()
		reticleCheck = true
		$UI/EyeUI.show()
	else:
		inventory_interface.set_player_inventory_data(player.inventory_data)
		inventory_interface.set_collectible_inventory_data(player.collectible_inventory_data)
		reticleCheck = true
		$UI/EyeUI.show()
		return

#updates save_data before saving updated data
func updateSaveData() -> void:
	save_data.enode_data = enode.enode_data
	save_data.inventory = player.inventory_data
	save_data.collectibles = player.collectible_inventory_data

#sets game variables and resources to what was loaded
func updateData() -> void:
	#sets inventory
	player.inventory_data = save_data.inventory
	inventory_interface.set_player_inventory_data(player.inventory_data)
	
	#sets collectibles
	player.collectible_inventory_data = save_data.collectibles
	inventory_interface.set_collectible_inventory_data(player.collectible_inventory_data)
	
	#sets enode
	enode.enode_data = save_data.enode_data
	enode.summon_level(enode.enode_data.current_level)
	#whichever func I use to update enode (likely summon_level)

#endregion
