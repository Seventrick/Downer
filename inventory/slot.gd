extends PanelContainer

signal slot_clicked(index: int, button: int)

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var slot: PanelContainer = $"."
@onready var item_highlight: TextureRect = $MarginContainer/TextureRect2

func set_slot_data(item_data: ItemData) -> void:
	texture_rect.texture = item_data.icon
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)
	
func _on_mouse_entered() -> void:
	modulate = Color(1,1,1,0.5)
	#item_highlight.show()

func _on_mouse_exited() -> void:
	modulate = Color(1,1,1,1)
	#item_highlight.hide()
