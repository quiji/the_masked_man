extends Node
class_name Leaf
var root = null

var data = null
var actor = null
var debugging = false
var is_first_run = true

const RunningBehaviour = 0 
const SucceededBehaviour = 1 
const FailedBehaviour = 2

var current_node_state 

func do_run(delta):

	if current_node_state == RunningBehaviour:
		if debugging:
			Console.add_log("AI Log ["+actor.name+"]", get_parent().get_parent().name + "::" + get_parent().name + "::" + name + " Running")
			#print("AI Log ["+actor.name+"]", get_parent().get_parent().name + "::" + get_parent().name + "::" + name + " Running")
		run(delta)
		
	elif debugging:
		if current_node_state == FailedBehaviour:
			Console.add_log("AI Log ["+actor.name+"]", get_parent().get_parent().name + "::" + get_parent().name + "::" + name + " Failed")
			#print("AI Log ["+actor.name+"]", get_parent().get_parent().name + "::" + get_parent().name + "::" + name + " Failed")
		else:
			Console.add_log("AI Log ["+actor.name+"]", get_parent().get_parent().name + "::" + get_parent().name + "::" + name + " Succeeded")
			#print("AI Log ["+actor.name+"]", get_parent().get_parent().name + "::" + get_parent().name + "::" + name + " Succeeded")

func failed():
	current_node_state = FailedBehaviour
	

func succeeded():
	current_node_state = SucceededBehaviour



func initialice():

	if is_first_run:
		is_first_run = false
		if get_parent().has_method("init"):
			root = get_parent().root
		else:
			root = get_parent()

		data = root.data
		actor = root.actor
		debugging = root.debugging

	current_node_state = RunningBehaviour

	init()
	

func get_state():
	return current_node_state

func run_child(idx):
	root.set_new_current_node(get_child(idx))


func child_returned(result):
	if result == SucceededBehaviour:
		child_succeeded()
	else:
		child_failed()

func is_leaf():
	return get_child_count() == 0

func is_composite():
	return false

func is_decorator():
	return not is_composite() and get_child_count() == 1



func init():
	pass

func child_succeeded():
	pass
	
func child_failed():
	pass

func run(delta):
	pass

