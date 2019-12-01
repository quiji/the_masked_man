extends LineEdit

var C = null
var commands = []
var current = -1

func _ready():
	connect("gui_input", self, "gui_input_entered")
	connect("text_entered", self, "run_command")



func queue_command(_text):
	commands.push_front(_text)

func gui_input_entered(ev):
	if Input.is_action_just_pressed("ui_up"):
		if current < commands.size() - 1:
			current += 1
			text = commands[current]
			select_all()
	elif Input.is_action_just_pressed("ui_down"):
		if current >= 0:
			current -= 1
			if current >= 0:
				text = commands[current]
			else:
				text = ''
			select_all()

func run_command(input):

	input = input.strip_edges()
	if input != '':
		var words = input.split(" ")
		var cmd = words[0]
		words.remove(0)
		
		if cmd[0] == '$' and cmd.find(".") == -1:
			words.insert(0, cmd)
			cmd = '$'
		elif cmd[0] == '$':
			var segments = cmd.split(".")
			cmd = segments[0]
			words.insert(0, segments[1])
			words.insert(0, cmd)
			cmd = "."
			
		C.run_command(cmd, words)
		
		queue_command(input)
		current = -1
		clear()
	
