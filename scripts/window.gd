extends StaticBody3D


func interact():
	if Items.screwdriver == true:
		$window2.hide() #i want the window animation here
		get_tree().call_group("moveables", "spawn") #spawn could be animation
