extends KinematicBody2D

const FACE_RIGHT: float = 1.0
const FACE_LEFT: float = -1.0

onready var sprite = $fella
onready var states = $states
onready var anims = $anims
onready var sfx_node = $sfx
onready var collision = $collision
onready var swipe_range = $swipe_range
onready var pierce_range = $pierce_range
onready var lancer_range = $lancer_range

export (NodePath) var battle_start_area_node
export (NodePath) var leap_target_node
export (NodePath) var wall_jump_node
export (NodePath) var camera_man_node
export (float) var lives = 20.0
export (float) var leap_speed = 200.0

var facing: float = FACE_RIGHT setget set_facing

var leap_points = []


var wall_jump_points = []

var enemy = null
var camera : CameraMan

func _ready():
	self.facing = FACE_RIGHT

	if camera_man_node:
		camera = get_node(camera_man_node)
	
	
	if battle_start_area_node:
		var area : Area2D = get_node(battle_start_area_node)
		
		area.connect("body_entered", self, "_on_leapers_arrival")

	if leap_target_node:
		leap_points.push_back(position)
		leap_points.push_back(get_node(leap_target_node).position + position)
		
	if wall_jump_node:
		var pos_nodes = get_node(wall_jump_node)
		for i in range(pos_nodes.get_child_count()):
			var child = pos_nodes.get_child(i)
			wall_jump_points.push_back(child.position + position)
			
	

func set_facing(is_it: float) -> void:
	#if facing == is_it:
	#	return
		
	facing = is_it
	
	sprite.flip_h = facing == FACE_RIGHT
	

func _on_leapers_arrival(body):
	get_node(battle_start_area_node).queue_free()
	
	enemy = body
	
	states.set_next("idle")


func _process(delta):
	
	states.run(delta)


func hit(attacker_position) -> int:
	#knockback_direction = attacker_position - position
	#knockback_direction = -knockback_direction.normalized()

	sfx_node.get_node("sword_hit").play()

	var current_lives: int = GUI.enemy_life_down()
	if current_lives > 0:
		if states.current_is("hit"):

			states.current.restart()
		else:
			states.set_next("hit")
	else:
		states.set_next("sword_death")
			
	
	return current_lives
	
