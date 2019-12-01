extends Node2D

var value = Vector2()
var color = null
var magnitude = 0
var x = 0
var y = 0
var default_font = null
var show_coords = false

func _ready():
	var label = Label.new()
	default_font = label.get_font("")
	label.free()

func set_value(val, col, meta):
	value = val.normalized()
	magnitude = val.length()
	color = col
	x = val.x
	y = val.y
	if meta != null and meta.show_coords:
		show_coords = true
	update()
	
func _draw():
	var target = value * 50
	var the_name = get_name() + '-' + str(magnitude)
	var the_coord = '(' + str(x) + ',' + str(y) + ')'
	draw_line(Vector2(), target, color, 2, true)
	draw_line(target, target + value * 5 , Color(0,0,0), 2, true)
	draw_string(default_font, target + value * 10, the_name, color)
	if show_coords:
		draw_string(default_font, target + value * 10 + Vector2(0, 14), the_coord, color)
	
	
	
	
