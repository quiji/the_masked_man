extends Sprite

export (bool) var sided = true
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	if sided:
		frame = 0
	else:
		frame = 1
	

