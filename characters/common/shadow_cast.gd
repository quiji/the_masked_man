extends RayCast2D

onready var shadow = $shadow

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if is_colliding():
		shadow.visible = true
		shadow.position = get_collision_point() - get_parent().position
		var t: float = clamp(1.0 - shadow.position.y / 78.0, 0.0, 2.0) 
		shadow.scale = Vector2(1, 1) * Smoothstep.stop2(t)
		shadow.modulate.a = 1.0 * Smoothstep.stop2(t)
	else:
		shadow.visible = false


