extends Area3D

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var done = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and !done:
		animation_player.play("paper_boat")
		done = true
