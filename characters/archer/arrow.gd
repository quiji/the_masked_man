extends Area2D

onready var sprite = $fella
onready var visibility_notifier = $notifier

var direction: float = 0.0



func _ready():
	hide()
	
	set_process(false)

func shoot(face_left: bool) -> void:
	
	connect("body_entered", self, "_on_arrow_collided")
	
	set_process(true)
	
	if face_left:
		direction = -1.0
	else:
		direction = 1.0
		sprite.flip_h = true
		
	show()
	
func _on_arrow_collided(target) -> void:
	

	
	if target.has_method("sword_hit"):
		target.sword_hit(position)
		queue_free()
	
	set_process(false)
	
func _process(delta):
	
	position += Vector2(direction, 0.0) * 400.0 * delta
	
	if not visibility_notifier.is_on_screen():
		queue_free()

		
		

