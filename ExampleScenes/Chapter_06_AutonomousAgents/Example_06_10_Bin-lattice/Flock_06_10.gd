extends Node2D

class_name Flock_06_10

func _process(delta):
	
	for b in get_children():
		b.flock(get_children())
		
