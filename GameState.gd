extends Node

enum ScreenLoadModes {Spawn, RoomEnter}

# Save Data:
var data = {

	spawn_scene = "res://levels/levels/left_wing_prison.tscn",
	spawn_position = Vector2(-289, 0),

	max_life_count = 3,
	life_pieces = 0,
	pit_door_opened = false,

	
	
	#spawn_position = Vector2(0, 0),
	
	
	#spawn_position = Vector2(40, -3460),
	#spawn_scene = "res://levels/levels/main_hall.tscn",
	#max_life_count = 20,
	#life_pieces = 0,
	#pit_door_opened = true
	
	
	#spawn_scene = "res://levels/levels/left_top_room.tscn",
	#spawn_scene = "res://levels/levels/right_wing_entrance.tscn",
	#spawn_scene = "res://levels/levels/right_wing_hall.tscn",
	#spawn_scene = "res://levels/levels/right_basement.tscn",
	#spawn_scene = "res://levels/levels/right_top_room.tscn",

}
var current_max_life_count = 0
var current_life_count = 0

var enter_door_name: String
var screen_load_mode: int
var current_scene: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _process(delta):
#	Console.add_log("GameState.data", data)

func spawn() -> void:
	current_max_life_count = data.max_life_count
	current_life_count = current_max_life_count
	SceneSwitcher.change_scene(data.spawn_scene)
	screen_load_mode = ScreenLoadModes.Spawn
	
func enter(new_scene, door_name) -> void:
	screen_load_mode = ScreenLoadModes.RoomEnter
	enter_door_name = door_name
	SceneSwitcher.change_scene(new_scene)

func register_checkpoint(spawn_position) -> void:
	data.spawn_scene = current_scene
	data.spawn_position = spawn_position
	data.max_life_count = current_max_life_count

func get_spawn_position() -> Vector2:
	return data.spawn_position
	
func set_object_state(level_name: String, object: String, dat) -> void:
	
	if not data.has(level_name):
		data[level_name] = {}
	
	data[level_name][object] = dat 
	
func get_object_state(level_name: String, object: String):
	if data.has(level_name) and data[level_name].has(object):
		return data[level_name][object]
	
	return null
	
func increment_max_life() -> void:
	current_max_life_count += 1
	data.max_life_count = current_max_life_count
	
func increment_life_pieces() -> bool:
	data.life_pieces += 1
	
	if data.life_pieces == 3:
		data.life_pieces = 0
		return true
		
	return false

func get_life_pieces() -> int:
	return data.life_pieces

func is_pit_opened() -> bool:
	return data.pit_door_opened
	
func open_pit() -> void:
	data.pit_door_opened = true
	

	
