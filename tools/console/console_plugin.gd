tool
extends EditorPlugin


func _enter_tree():
	var key = InputEventKey.new()
	key.scancode = KEY_F1
	ProjectSettings.set("autoload/Console", "*res://addons/quijipixel.console/Console.tscn")
	
	ProjectSettings.set("input/toggle_console", [key])
	ProjectSettings.save()

	
func _exit_tree():
	ProjectSettings.clear("autoload/Console")
	ProjectSettings.clear("input/toggle_console")
	ProjectSettings.save()
