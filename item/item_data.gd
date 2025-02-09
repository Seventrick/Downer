extends Resource
class_name ItemData

signal item_used

@export var name: String = ""
@export_multiline var description: String = ""
@export var icon: Texture

func use() -> void:
	item_used.emit()
