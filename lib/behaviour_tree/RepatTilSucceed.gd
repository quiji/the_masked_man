extends "res://lib/behaviour_tree/BehaviourClass.gd"
class_name BehaviourRepeatSucceed

	
func run(delta):

	run_child(0)


func child_succeeded():
	succeeded()
	
func child_failed():
	pass





