extends Node



################################
const DEV_MODE = false
################################


enum ControllerTypes {Keyboard, Nintendo, Playstation, Xbox}


func _ready():
	if DEV_MODE:
		Console.active = true
	else:
		Console.active = false
	set_process(false)
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	Console.add_command("open_doors", self, "_open_doors", "Open all block doors")
	Console.add_command("close_doors", self, "_close_doors", "Close all block doors")




func _open_doors(args) -> void:
	
	if args.size() > 0:
		get_tree().call_group("block_doors", "open_if_owner", args[0])
	else:
		get_tree().call_group("block_doors", "open")

func _close_doors(args) -> void:
	
	if args.size() > 0:
		get_tree().call_group("block_doors", "close_if_owner", args[0])
	else:
		get_tree().call_group("block_doors", "close")



func get_input_type() -> int:
	var joys = Input.get_connected_joypads()
	
	
	if joys.size() == 0:
		return ControllerTypes.Keyboard
	else:
		
		var joy_name = Input.get_joy_name(joys[0])
		if joy_name.findn("nintendo") > -1:
			return ControllerTypes.Nintendo
		elif joy_name.findn("ps1") > -1 or joy_name.findn("ps2") > -1 or joy_name.findn("ps3") > -1:
			return ControllerTypes.Playstation
		elif joy_name.findn("xbox") > -1:
			return ControllerTypes.Xbox
			
		return ControllerTypes.Keyboard
	
