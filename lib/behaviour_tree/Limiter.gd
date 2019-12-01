extends "res://lib/behaviour_tree/BehaviourClass.gd"
class_name BehaviourLimiter

export (int) var execution_limit = 1

var total_executions = 0

func init():
	
	if total_executions >= execution_limit:
		failed()
		return
	
	total_executions += 1
	
func run(delta):
	.run(delta)
	run_child(0)

func child_succeeded():
	succeeded()
	
func child_failed():
	failed()




