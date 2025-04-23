extends Control


var next_scene = "res://scenes/main.tscn"

func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene)


func _process(delta: float) -> void:
	var progress = []
	ResourceLoader.load_threaded_get_status(next_scene, progress)
	$TextureProgressBar.value = progress[0]*100
	
	if progress[0] == 1:
		var packed_scene = ResourceLoader.load_threaded_get(next_scene)
		get_tree().change_scene_to_packed(packed_scene)
