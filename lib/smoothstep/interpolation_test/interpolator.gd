tool
extends Node2D

var Smoothstep = preload("../Smoothstep.gd")


var size = 100
var anim_duration = 1.3
var m_owner = null
var method = ""
var percentage = 0.0
var right = true

var start_x = 0
var start_lerp_x = 0
var start = Vector2()
var target = Vector2(size, size)
func _ready():
	

	start_x = $smooth.position.x
	start_lerp_x = $lerp.position.x
	target = Vector2(size, -size)
	$end.position = Vector2(size, 0)

func set_method(o, m):
	m_owner = o
	method = m

	update()

func _draw():
	if m_owner != null:
		var points = Smoothstep.graph(m_owner, method, size)
		draw_multiline(points, Color(1.0, 0.2, 0.2), 2.0)

var x = 0
var lerp_x = 0
var pos = Vector2()
func _physics_process(delta):
	if m_owner == null:
		return null

	percentage += delta / anim_duration
	#percentage += 0.01
	if right and percentage > 1.0:
		right = false
		percentage = 0.0
		x = size
		lerp_x = size
		pos = target
	elif percentage > 1.0:
		right = true
		percentage = 0.0
		x = 0
		lerp_x = 0
		pos = Vector2()

	if right:
		var smooth_t = m_owner.call(method, percentage)
		x = Smoothstep.linear_interp(0, size, smooth_t)
		lerp_x = Smoothstep.linear_interp(0, size, percentage)
		pos = Vector2(percentage * size, -smooth_t * size)
	else:
		var smooth_t = m_owner.call(method, percentage)
		x = Smoothstep.linear_interp(size, 0, smooth_t)
		lerp_x = Smoothstep.linear_interp(size, 0, percentage)
		pos = Vector2(percentage * size, -smooth_t * size)

	$smooth.position.x = start_x + x
	$lerp.position.x = start_lerp_x + lerp_x
	$func.position = pos
