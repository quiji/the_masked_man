extends "res://lib/behaviour_tree/BehaviourClass.gd"
class_name BehaviourFailer

	
func run(delta):
	run_child(0)

func child_succeeded():
	failed()
	
func child_failed():
	failed()




