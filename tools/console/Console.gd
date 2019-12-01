extends CanvasLayer

var code_input = null
var out = null
var vector_node = preload("res://tools/console/vector_node.tscn")
var commands = {}
var res_size = Vector2()
var active := true

func _ready():
	code_input = $window/container/code_input
	out = $window/container/out
	res_size = OS.get_window_size() / 2
	$debug_control.set_position(res_size)

	code_input.set('C', self)
	$window.hide()
	
	add_command("help", self, "_help", "Shows this command list")
	add_command("$", self, "_get_node", "Find and load node into a $<name> variable. Nodes must be loaded first in order for them to be manipulated.")
	add_command("methods", self, "_list_methods", "List the methods of the $<name> node passed as argument")
	add_command("properties", self, "_list_properties", "List the properties of the $<name> node passed as argument")
	add_command(".", self, "_execute", "$<name>.<property> to show content, $<name>.<property> <type:f/i/s> <new_value> to assign or $<name>.<method> <argument1> <argument2> to execute.")
	add_command("log", self, "_activate_log", "Activate/deactivate by running log on/off")
	add_command("reboot", self, "_reboot", "Restart current scene")
	add_command("unpause", self, "_unpause", "Unpause game")
	add_command("force_fps", self, "_force_fps", "Force game to target fps")
	
func _input(ev):
	if active:
		if Input.is_key_pressed(KEY_F1):
			if $window.visible:
				$window.hide()
			else:
				$window.show()
				code_input.grab_focus()


func add_command(_name, obj, function, data):
	if !commands.has(_name):
		commands[_name] = [{object = obj, method = function, info = data}]
	else:
		commands[_name].push_back({object = obj, method = function, info = data})

func remove_command(_name, obj, function):
	if commands.has(_name):
		var i := 0
		var found := false
		while i < commands.size() and not found:
			if commands[_name][i].object == obj and commands[_name][i].method == function :
				commands[_name].remove(i)
				found = true
			i += 1


func run_command(cmd, att):
	if !commands.has(cmd):
		out.warn("Command 0¡ doesn't exist", [cmd])
	else:
		var i = 0
		while i < commands[cmd].size():
			commands[cmd][i].object.call(commands[cmd][i].method, att)
			i += 1


################################################
# Visual log API
################################################

var var_pool = {}
func la(obj, value):
	var_pool[value] = obj

func dot(pos: Vector2) -> void:
	$dots.append_dot(pos)


var logs = {}
func add_log(obj, _name, _meta=null):
	# polymorphic variables... darn
	if typeof(obj) == TYPE_STRING:
		if not logs.has(obj):
			logs[obj] = {object = null, prop = obj, value = _name, meta = _meta, color = Color(rand_range(0.3, 1), rand_range(0.3, 1), rand_range(0.3, 1) )}
		else:
			logs[obj].value = _name
			logs[obj].meta = _meta
	else:
		var new_name = obj.get_class() + '.' + _name
		if not logs.has(new_name) and obj != null:
			logs[new_name] = {object = obj, prop = _name, value = null, meta = _meta, color = Color(rand_range(0.3, 1), rand_range(0.3, 1), rand_range(0.3, 1) )}

func count(_name, accum=1):
	if not logs.has(_name):
		logs[_name] = {object = null, prop = _name, value = 0, color = Color(rand_range(0.3, 1), rand_range(0.3, 1), rand_range(0.3, 1) )}
	else:
		logs[_name].value += accum

func p(_msg):
	out.info(_msg)

func clear():
	out.clear()

func get_prop(_name):
	if logs[_name].object == null:
		return logs[_name].value
	else:
		return logs[_name].object.get(logs[_name].prop)

func _physics_process(delta):
	
	if not active:
		set_physics_process(false)
		return
	
	$debug_text.clear()
	for the_name in logs:
		var the_val 
		the_val = get_prop(the_name)
		if typeof(the_val) == TYPE_VECTOR2:
			if not $debug_control.has_node(the_name):
				var vect = vector_node.instance()
				vect.set_name(the_name)
				$debug_control.add_child(vect)
			get_node("debug_control/" + the_name).set_value(the_val, logs[the_name].color, logs[the_name].meta)
		else:
			$debug_text.append_bbcode("[color=#" + logs[the_name].color.to_html() + "]" + the_name + "[/color]: " + str(the_val))
			$debug_text.newline()
	
	$fps.text = str(Engine.get_frames_per_second())
	
var _visual_log_on = false
func set_visual_log(val):
	_visual_log_on = val
	if _visual_log_on:
		$debug_text.show()
		$debug_control.show()
		set_physics_process(true)
	else:
		$debug_text.hide()
		$debug_control.hide()
		set_physics_process(false)

################################################
# Command implementation
################################################

func _help(args):
	out.info("Command list:")
	for key in commands:
		out.info("  - 0¡:  " + commands[key][0].info, [key])

var nodes = {}
func _get_node(_att):
	var _varname = _att[0]
	if nodes.has(_varname):
		
		var children = nodes[_varname].get_children()
		out.newline()
		

		for child in children:
			out.info("  - 0¡::1¡", [child.get_name(), child.get_class()])
		out.info("0¡::1¡ has 2¡ children", [nodes[_varname].get_path(), nodes[_varname].get_class(), nodes[_varname].get_child_count()])
			
	else:
		var _node = _att[1]

		var n = get_tree().current_scene.find_node(_node)
			
		if n == null:
			out.info("Node 0¡ couldn't be found...", [_node])
		else:
			out.info("1¡ = 0¡", [n.get_path(), _varname])
			nodes[_varname] = n


func _list_methods(args):
	var _var = null
	if args.size() == 1:
		_var = args[0]

	if _var == null:
		out.warn("The parameters of the command are not as expected, use the 0¡ command for assistance.", ["help"])
	elif not nodes.has(_var):
		out.warn("The node must be loaded with the $ command.")
	else:
		var props = nodes[_var].get_method_list()
		var i = 0
		for prop in props:
			if prop.id == 0:
				i += 1
				out.info("  - 0¡", [prop.name])
		out.info("0¡::1¡ has 2¡ methods", [nodes[_var].get_path(), nodes[_var].get_class(), i])

func _list_properties(args):
	var _var = null
	if args.size() == 1:
		_var = args[0]
	
	if _var == null:
		out.warn("The parameters of the command are not as expected, use the 0¡ command for assistance.", ["help"])
	elif not nodes.has(_var):
		out.warn("The node must be loaded with the $ command.")
	else:
		var props = nodes[_var].get_property_list()
		var can_show = false
		var i = 0
		for prop in props:
			if can_show:
				out.info("  - 0¡", [prop.name])
				i += 1
			elif prop.name == 'Script Variables':
				can_show = true
		out.info("0¡::1¡ has 2¡ properties", [nodes[_var].get_path(), nodes[_var].get_class(), i])


func transform_argument_types(args):
	var new_args = []
	var fl = RegEx.new()
	var bl = RegEx.new()
	var nt = RegEx.new()

	#float
	fl.compile('^[+-]?([0-9]*[\\.\\,]?[0-9]+|[0-9]+[\\.\\,]?[0-9]*)([eE][+-]?[0-9]+)?$')
	
	#bool
	bl.compile('^(1|0|true|false)$')
	
	#int
	nt.compile('^\\d+$')



	for arg in args:
		var result_float = fl.search(arg)
		var result_bool = bl.search(arg)
		var result_int = nt.search(arg)
		
		var temp = arg.strip_edges()
		
		if temp.begins_with('Vector2(') and temp.ends_with(')') and temp.find(',')  > -1:
			temp = temp.replace("Vector2(", '')
			temp = temp.replace(')', '')
			temp = temp.replace(" ", '')
			
			var coords = temp.split(',')
			new_args.push_back(Vector2(coords[0].to_float(), coords[1].to_float()) )
		elif result_float.get_start() > -1:
			new_args.push_back(arg.to_float())
		elif result_bool.get_start() > -1:
			new_args.push_back(arg.to_bool() )
		elif result_int.get_start() > -1:
			new_args.push_back(arg.to_int() )
	return new_args

func _execute(args):
	var _var = null
	var _prop = null
	if args.size() > 1:
		_var = args[0]
		_prop = args[1]
		args.remove(0)
		args.remove(0)
		
	if _var == null:
		out.warn("The parameters of the command are not as expected, use the 0¡ command for assistance.", ["help"])
	elif not nodes.has(_var):
		out.warn("The node must be loaded with the $ command.")
	else:
		if nodes[_var].has_method(_prop):
			out.info("Running 0¡.1¡...", [_var, _prop])
			var res = nodes[_var].callv(_prop, transform_argument_types(args))
			if res != null:
				out.info("result: 0¡", [res])
		elif args.size() == 0:
			out.info("0¡", [nodes[_var].get(_prop)])
		elif args.size() == 1:
			var val = transform_argument_types(args)
			out.info("Setting 0¡.1¡ to 2¡...", [_var, _prop, val[0]])
			nodes[_var].set(_prop, val[0])
		else:
			out.warn("The parameters of the command are not as expected, use the 0¡ command for assistance.", ["help"])

func _activate_log(args):
	if args.size() != 1 or args[0] != 'on' and args[0] != 'off':
		out.warn("The parameters of the command are not as expected, use the 0¡ command for assistance.", ["help"])
	elif args[0] == 'on':
		set_visual_log(true)
		out.info("Logging...")
	else:
		set_visual_log(false)
		out.info("Finished logging.")

func _force_fps(args):
	if args.size() != 1:
		out.warn("The parameters of the command are not as expected, use the 0¡ command for assistance.", ["help"])
	else:
		Engine.target_fps = int(args[0])
		out.info("Forcing to 0¡...", [args[0]])


func _reboot(args):
	out.info("Rebooting scene...")
	set_physics_process(false)
	get_tree().reload_current_scene()

func _unpause(args):
	out.info("Unpausing game...")
	get_tree().set_pause(false)
