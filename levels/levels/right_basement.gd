extends "res://levels/level.gd"


onready var switch = $back_elements/switch

onready var anims = $anims


func _ready():
	._ready()
	
	switch.connect("switched", self, "_on_switched")
	
	Maestro.long_battles()



func _on_switched():
	
	GameState.open_pit()
	
	anims.play("open_door")


func shake():
	camera_crew.camera_man.shake(1.4, 6.0, 0.0, camera_crew.camera_man.ShakeDirectionTypes.X_AXIS, camera_crew.camera_man.ShakeMovementTypes.ARCH)

