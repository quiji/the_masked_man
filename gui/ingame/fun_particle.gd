tool
extends Node2D


var start: Vector2
var target: Vector2
var t: float = 0.0

var velocity: Vector2

func _ready():
	set_physics_process(false)
	

func emit(from: Vector2, to: Vector2) -> void:
	target = to
	start = from
	position = start
	t = 0.0
	show()
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	

	position.x = lerp(start.x, target.x, Smoothstep.normalized_bezier7(0.3, 0.4, 0.8, 1.7, 1.2, 0.8, t))
	position.y = lerp(start.y, target.y, Smoothstep.start2(t))
	#position = start.linear_interpolate(target, Smoothstep.start2(t))

	t += delta / 1.0

	if t > 1.0:
		hide()
		set_physics_process(false)
		

func _draw() -> void:
	
	draw_circle(Vector2(), 10.0, Color("c3eacf") )
	
