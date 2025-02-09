extends AnimatableBody3D


@onready var box = $"."

var startPos



func interact():
	pass
	
func interact_box():
	pass
	

func _ready() -> void:
	startPos = box.global_position

func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	
	#if %BoxZone.is_colliding():
		#var target = %BoxZone.get_collider(0)
		#print(target)
		#if target != null and target.is_in_group("lightSources"):
		#	pass
	#else:
		#print("box reset")
		#box.set_global_position(startPos)
		
		
	#if %WindowZone.is_colliding():
		#var target = %WindowZone.get_collider(0)	
		#if target != null and target.is_in_group("window"):
			#print("window boxed >:0")
			
	pass
