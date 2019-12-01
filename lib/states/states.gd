extends Node
class_name CharacterActionStates


export (bool) var visual_log := false

var blocked = false
var current = null
var next = null
var next_sub_state : String
var block = false
var input_blocked := false
var data = null
var state_runtime := 0.0
var prev = null


func _ready():
	
	if get_child_count() > 0:
		next = get_child(0)

func run(delta: float):
	
	
	if next != current:
		
		if visual_log and current != null:
			Console.add_log(get_parent().name +"_prev_state", current.name)
			Console.add_log(get_parent().name +"_state_runtime", state_runtime)
		state_runtime = 0.0
		
		current = next
		if current.first_run:
			current.install()
			current.first_run = false
		current.start(next_sub_state)
		data = null
		if visual_log:
			print(get_parent().name +"_state: ", current.name)

	if current != null and current.restarting:
		current.start("")
		current.restarting = false
		if visual_log:
			print(get_parent().name + "_" + current.name, " restarted" )

	state_runtime += delta
	if current != null:
		current.run(delta)
		if visual_log:
			Console.add_log(get_parent().name +"_state", current.name)




func _unhandled_input(event):


	if current != null and not blocked and not input_blocked:
		current.handle_input(event)



func set_next(new_state: String, sub_state: String = "") -> void:
	if current.restarting:
		return

	prev = current
	next = get_node(new_state)
	next_sub_state = sub_state
	if prev != null:
		prev.end(new_state)

func current_is(current_name: String) -> bool:
	if current != null:
		return current.name == current_name
	else:
		return false

func prev_is(prev_state: String) -> bool:
	if prev == null:
		return false

	return prev.name == prev_state

func get_state(state_name: String):
	return get_node(state_name)

