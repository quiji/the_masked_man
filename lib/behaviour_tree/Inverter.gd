extends "res://lib/behaviour_tree/BehaviourClass.gd"
class_name BehaviourInverter
	
	
func run(delta):

	run_child(0)

func child_succeeded():
	failed()
	
func child_failed():
	succeeded()




