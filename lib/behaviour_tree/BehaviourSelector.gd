extends "res://lib/behaviour_tree/BehaviourClass.gd"

class_name BehaviourSelector

var current_node = 0

func init():
	current_node = 0

func run(delta):

	if current_node >= get_child_count():
		failed()
	else:
		run_child(current_node)


func child_succeeded():
	succeeded()
	
func child_failed():
	current_node += 1

func is_composite():
	return true
