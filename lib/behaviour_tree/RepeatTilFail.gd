extends "res://lib/behaviour_tree/BehaviourClass.gd"
class_name BehaviourRepeatFail
	
func run(delta):

	run_child(0)

func child_succeeded():
	pass
	
func child_failed():
	succeeded()




