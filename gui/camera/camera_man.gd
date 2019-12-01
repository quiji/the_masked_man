
extends Camera2D

class_name CameraMan, "res://gui/camera/icon.png"

enum ShakeDirectionTypes {X_AXIS, Y_AXIS, ALL_DIRECTIONS, GIVEN_DIRECTION}
enum ShakeMovementTypes {ARCH, STRONG_TO_LOW}

onready var _shake = preload("./screenshake.gd").new(self)



func _ready():
	
	set_physics_process(false)
	pass

func _physics_process(delta):
	
	if not _shake.process(delta):
		set_physics_process(false)
		



func shake(duration, amp, rot_amp, shk_type, shk_mov_type, given_dir=null):
	
	
	_shake.shake(duration, amp, rot_amp, shk_type, shk_mov_type, given_dir)
	set_physics_process(true)



