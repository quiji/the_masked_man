extends Node

class_name BehaviourTree

export (bool) var autorun = true
export (bool) var debugging = false

const RunningBehaviour = 0 
const SucceededBehaviour = 2 
const FailedBehaviour = 3


var actor = null
var data = null


var current_node = null

func _ready():

	actor = get_parent()

	if get_child_count() == 2:
		data = get_child(1)


	set_process(autorun)


func run():
	pass
	#set_process(true)

func child_returned(result):
	pass
	#set_process(false)

var fps = 40.0
var deltas = 0
var current_state
var last_was_leaf := false
var run_id = 0
#func _process(delta):
func run_ai(delta: float):


	
	deltas -= delta
	
	if deltas <= 0:
		run_id += 1
		if current_node == null:
			set_new_current_node(get_child(0))

		"""
		last_was_leaf = false
		while not last_was_leaf:
			current_state = current_node.get_state() 
	
			if current_state != RunningBehaviour:
				return_to_parent(current_node, current_state)

			last_was_leaf = current_node.is_leaf()
			current_node.do_run(delta)

		"""
		current_state = current_node.get_state() 

		if current_state != RunningBehaviour:
			return_to_parent(current_node, current_state)

		current_node.do_run(delta)
		#"""
		
		deltas = 1.0 / fps

	if run_id > 100000:
		run_id = 0


func set_new_current_node(node):
	current_node = node
	current_node.initialice()

func return_to_parent(node, result):
	current_node = node.get_parent()
	current_node.child_returned(result)
