extends Control

onready var arrow = $arrow
onready var anims = $anims

var actor = null

func _ready():
	set_process(false)
	arrow.hide()
	

func appear(who: Position2D):
	arrow.show()
	anims.play("Appear")
	set_process(true)
	actor = who

func disappear():
	anims.play("Disappear")
	set_process(false)
	actor = null
	
	
func _process(delta):
	
	if actor == null:
		return
		
	rect_position = actor.get_global_transform_with_canvas().get_origin()
	
