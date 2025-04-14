extends CharacterBody2D

#testing repo update hello hello world

var player_area
var walking = false

@export var speed = 355  # speed in pixels/sec

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact: AnimatedSprite2D = $UI/AnimatedSprite2D

func _process(_delta: float) -> void:
	if player_area != null and Input.is_action_just_pressed("interact"):
		#print("mommy mommy mommy mommy")
		pass

func _physics_process(_delta):
	
	if !PlayerState.movementLock:
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * speed
		
		if direction.x < 0:
			animated_sprite.flip_h = false
		elif direction.x > 0:
			animated_sprite.flip_h = true

		
		if !(direction.x or direction.y):
			animated_sprite.play("idle")
			walking = false
		else:
			animated_sprite.play("run")
			walking = true
		
		move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("interactable"):
		player_area = area
		interact.show()
		#print("interacting")

func _on_area_2d_area_exited(_area: Area2D) -> void:
	player_area = null
	interact.hide()


func _on_walk_timeout() -> void:
	if walking == true:
		$footsteps.play()
	else:
		$footsteps.stop()
