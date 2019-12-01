extends Node
class_name CharacterAction

var actor
var states
var first_run := true
var restarting: bool = false

func _ready() -> void:
	states = get_parent()
	actor = states.get_parent()

func go_to(new_state: String, sub_state: String = '') -> void:
	states.set_next(new_state, sub_state)

	
func i_am_current_state() -> bool:
	return states.current == self
	
func restart() -> void:


	restarting = true
	states.next = self
	
##############################################################
#
#  Virtual Methods
#
##############################################################

func install() -> void:
	pass

func start(sub_state: String) -> void:
	pass
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	pass
	
func handle_input(event: InputEvent):
	pass
