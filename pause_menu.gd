extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	hide()
	
	$menu/vbox/continue.connect("pressed", self, "_on_continue")
	$menu/vbox/quit.connect("pressed", self, "_on_quit")

func _on_continue():
	hide()
	get_tree().paused  = false
	
func _on_quit():
	get_tree().quit()

func _unhandled_input(event):
	
	if event.is_action_released("pause"):
		get_tree().paused  = not get_tree().paused
		
		visible = get_tree().paused
		
		if visible:
			$menu/vbox/continue.grab_focus()

