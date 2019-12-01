extends "res://lib/behaviour_tree/BehaviourClass.gd"
class_name BehaviourRepeater

export (int) var repeat_times = 0


var how_many_times = null
func init():
	if repeat_times > 0:
		how_many_times = repeat_times

func run(delta):
	
	if how_many_times != null:
		how_many_times -= 1
		if how_many_times == 0:
			succeeded()
		else:
			run_child(0)
	else:
		run_child(0)


func child_succeeded():
	pass
	
func child_failed():
	pass






