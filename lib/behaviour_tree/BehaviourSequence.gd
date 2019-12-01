extends "res://lib/behaviour_tree/BehaviourClass.gd"
class_name BehaviourSequence

var current_node = 0

func init():
	current_node = 0

func run(delta):
	
	if current_node >= get_child_count():
		succeeded()
	else:
		run_child(current_node)


func child_succeeded():
	current_node += 1
	
func child_failed():
	failed()

func is_composite():
	return true





