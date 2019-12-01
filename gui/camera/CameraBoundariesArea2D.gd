tool
extends Area2D

class_name CameraBoundaries

const LAST_COLLISION_LAYER :int = 524288

export (int) var box_priority
export (int) var box_limit_top setget set_box_limit_top
export (int) var box_limit_bottom setget set_box_limit_bottom
export (int) var box_limit_left setget set_box_limit_left
export (int) var box_limit_right setget set_box_limit_right

var limit_top: int
var limit_bottom: int
var limit_left: int
var limit_right: int

func _ready():
	collision_mask = LAST_COLLISION_LAYER
	collision_layer = LAST_COLLISION_LAYER
	monitoring = false

	limit_top = position.y + box_limit_top
	limit_bottom = position.y + box_limit_bottom
	limit_left = position.x + box_limit_left
	limit_right = position.x + box_limit_right


func set_box_limit_top(new_limit: int) -> void:
	if box_limit_top == new_limit:
		return
		
	box_limit_top = new_limit
	
	if Engine.editor_hint:
		update()

func set_box_limit_bottom(new_limit: int) -> void:

	if box_limit_bottom == new_limit:
		return

	box_limit_bottom = new_limit

	if Engine.editor_hint:
		update()

func set_box_limit_left(new_limit: int) -> void:
	
	if box_limit_left == new_limit:
		return

	box_limit_left = new_limit

	if Engine.editor_hint:
		update()

func set_box_limit_right(new_limit: int) -> void:
	
	if box_limit_right == new_limit:
		return

	box_limit_right = new_limit

	if Engine.editor_hint:
		update()

func _draw():
	
	if not Engine.editor_hint:
		return
		
	draw_rect(Rect2(box_limit_left, box_limit_top, -box_limit_left + box_limit_right, -box_limit_top + box_limit_bottom), Color(0.8, 0.8, 0.4), false, 4)
