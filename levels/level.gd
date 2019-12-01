extends Node2D

onready var leaper = $leaper
onready var doors = $doors
onready var camera_crew = $camera_crew
onready var blocks = $blocks

func _ready():
	
	if GameState.screen_load_mode == GameState.ScreenLoadModes.Spawn:
		leaper.position = GameState.get_spawn_position()
		GUI.open_player_health_bar()
	elif doors.has_node(GameState.enter_door_name):
		var door = doors.get_node(GameState.enter_door_name)
		leaper.position = door.spawn_position
		leaper.facing = door.get_facing()
		
	GUI.level_loaded()
	
	camera_crew.force_update()

	GameState.current_scene = filename
	
	blocks.material = ShaderMaterial.new()
	blocks.material.shader = preload("res://shaders/lights.shader")
	
	Maestro.short_battles()
