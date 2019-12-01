tool
extends StaticBody2D

export (float) var width = 32 setget set_width


func set_width(new_width: float) -> void:
	width = new_width
	
	$collision.shape.extents.x = width / 2
	$sprite.rect_size.x = width
	$sprite.rect_position.x = -width / 2
