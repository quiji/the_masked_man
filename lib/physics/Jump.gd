extends Node

class_name Jump

export (float) var run_speedo = 0.0 
export (float) var jump_height = 0.0 
export (float) var total_distance = 0.0 
export (float) var peak_point_t = 0.0 

var jump_time: float = 0.0
var fall_time: float = 0.0
var initial_speed: float = 0.0
var jump_gravity: float = 0.0
var fall_gravity: float = 0.0


func _ready():
	_recalc()
	
func update_run_speedo(new_speedo: float) -> void:
	run_speedo = new_speedo
	_recalc()

func _recalc() -> void:
	var first_distance = total_distance * peak_point_t
	var second_distance = total_distance - first_distance

	jump_time = first_distance / run_speedo
	fall_time = second_distance / run_speedo

	initial_speed = 2 * jump_height / jump_time
	jump_gravity = -2 * jump_height / (jump_time * jump_time)

	fall_gravity = -2 * jump_height / (fall_time * fall_time)
	

