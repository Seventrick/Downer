extends Node3D

@onready var sprite: Node3D = $"."
@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var filter = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("UI").get_node("ColorRect2")

@onready var innittowinit = false

@onready var interference = 0.037
@onready var noise = 0.025

@onready var distanceFromDowner
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"


func _process(_delta: float) -> void:
	sprite.look_at(player.global_position, Vector3.UP)
	sprite.rotation = sprite.rotation.clamp(Vector3(0, -1000000000000, 0), Vector3(0, 100000000000, 0))
	# needs fixed?????
	
	distanceFromDowner = player.global_position.distance_to(global_position)
	
	if innittowinit:
		noise = remap(distanceFromDowner, 15, 0, 0.025, 2)
		interference = remap(distanceFromDowner, 15, 0, 0.037, 2)
		filter.material.set_shader_parameter("interference_amount", interference)
		filter.material.set_shader_parameter("noise_amount", noise)
		
	if distanceFromDowner <= 7:
		print("bae")
		get_tree().paused = true
		pass








func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		innittowinit = true
		#await get_tree().create_timer(10).timeout
		#audio_stream_player.play()
		
