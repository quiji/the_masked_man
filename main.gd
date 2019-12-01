extends Node


func _ready():
	

	OS.window_maximized = true

	SceneSwitcher.change_scene("res://gui/screens/main_screen.tscn")
	#GameState.spawn()

	
