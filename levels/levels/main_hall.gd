extends "res://levels/level.gd"

onready var dust = $back_elements/dust
onready var pit_door = $front_elements/pit_door
onready var down_sun = $down_sun
onready var up_sun = $up_sun

# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	
	if not GameState.is_pit_opened():
		dust.queue_free()
		down_sun.queue_free()
	else:
		pit_door.queue_free()
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
