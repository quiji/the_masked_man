extends Node2D


export var dots = [] setget set_dots


func set_dots(new_dots) -> void:
	dots = new_dots
	update()

func _draw():
	
	var i = 0
	
	while i < dots.size():
		
		draw_circle(dots[i], 2, Color(0.5, 0.5, 1.0))
		
		i += 1
	