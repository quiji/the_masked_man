extends KinematicBody2D

onready var states = $states
onready var anims = $anims
onready var sprite = $leaper_sprite
onready var ground_cast = $ground_cast
onready var wall_cast = $wall_cast
onready var ledge_cast = $ledge_cast
onready var shadow_cast = $shadow_cast
onready var up_leap_cast = $up_leap_cast
onready var jumps = $jumps
onready var attack_range = $attack_range
onready var sfx_steps = $sfx/steps
onready var sfx_node = $sfx
onready var sfx_leapsteps = $sfx/leapsteps


const FACE_RIGHT: float = 1.0
const FACE_LEFT: float = -1.0

export (float) var run_speed = 140.0
export (float) var time_to_top_run_speed = 0.4
export (float) var time_to_stop_run= 0.3
export (float) var time_to_move_midair= 0.2
export (float) var coyote_time = 0.1
export (float) var vertical_coyote_time = 0.3
export (float) var jump_preorder_time = 0.1
export (float) var leap_distance = 96
export (float) var up_leap_distance = 68
export (NodePath) var camera_man_node


var facing: float = 0.0 setget set_facing
var velocity: Vector2 
var max_life_count: int
var current_life: int

var coyote_timer: float
var coyote_wall_timer: float
var _wall_cast_vector: Vector2

var camera
var checkpoint = null

var knockback_direction: Vector2
var knockback_double: bool
var spike_hit_respawn_positon: Vector2

var current_step_sfx: int = 0
var current_leapstep_sfx: int = 0

func _ready():
	_wall_cast_vector = wall_cast.cast_to
	self.facing = FACE_RIGHT
	
	
	
	if camera_man_node:
		camera = get_node(camera_man_node)

func set_facing(is_it: float) -> void:
	if facing == is_it:
		return
		
	facing = is_it
	
	sprite.flip_h = facing == FACE_LEFT
	wall_cast.cast_to = _wall_cast_vector * facing
	ledge_cast.cast_to = _wall_cast_vector * facing
	up_leap_cast.cast_to = _wall_cast_vector * facing
	ledge_cast.force_raycast_update()
	wall_cast.force_raycast_update()
	up_leap_cast.force_raycast_update()

func _physics_process(delta):
	
	states.run(delta)
	
	#$debug.text = states.current.name
	
	
	if ground_cast.is_colliding() and coyote_timer < coyote_time:
		coyote_timer = coyote_time
	elif not ground_cast.is_colliding():
		coyote_timer -= delta
	
	
	if wall_cast.is_colliding() and coyote_wall_timer < vertical_coyote_time:
		coyote_wall_timer = vertical_coyote_time
	elif not wall_cast.is_colliding():
		coyote_wall_timer -= delta
	
func is_on_ground(valid_coyote:bool = true) -> bool:
	return ground_cast.is_colliding() or (coyote_timer > 0.0 and valid_coyote)

func is_touching_wall(valid_coyote:bool = false) -> bool:
	if wall_cast.is_colliding() and wall_cast.get_collider().has_method("set_facing"):
		return false
	
	#if not wall_cast.is_colliding() and coyote_wall_timer > 0.0 and valid_coyote:
	#	Console.add_log("coyote_wall_timer", coyote_wall_timer)
	
	return wall_cast.is_colliding() or (coyote_wall_timer > 0.0 and valid_coyote)
	
func is_ledge_availible() -> bool:
	if wall_cast.is_colliding() and wall_cast.get_collider().has_method("set_facing"):
		return false
	return wall_cast.is_colliding() and not ledge_cast.is_colliding()
	

func is_up_leap_connecting_wall() -> bool:
	return up_leap_cast.is_colliding()
	
func checkpoint_availible(new_point) -> void:
	checkpoint = new_point

	
func checkpoint_unavailible() -> void:
	checkpoint = null


func register_checkpoint() -> void:

	checkpoint.water_drank()
	GameState.register_checkpoint(position)
	GUI.full_heal()

func is_attacking() -> bool:
	return states.current_is("attack") or states.current_is("2nd_attack")
	
func sword_hit(attacker_position, is_double_push: bool = false) -> int:
	
	var current_lives :int = GUI.player_life_down()
	
	sfx_node.get_node("sword_hit").play()
	
	if current_lives > 0:
		states.set_next("sword_hit")
	else:
		states.set_next("sword_death")
		Maestro.end_battle()
	
	knockback_double = is_double_push
	knockback_direction = attacker_position - position
	knockback_direction = -knockback_direction.normalized()

	return current_lives
	

func spike_hit(respawn_position: Vector2) -> int:
	var current_lives :int = GUI.player_life_down()
	spike_hit_respawn_positon = respawn_position
	
	sfx_node.get_node("sword_hit").play()
	
	if current_lives > 0:
		states.set_next("spike_hit")
	else:
		states.set_next("sword_death")
	

	return current_lives
	

func sfx(type: String) -> void:

	match type:
		"steps":
			
			if current_step_sfx >= sfx_steps.get_child_count() - 1:
				current_step_sfx = 0
			else:
				current_step_sfx += 1
				
			sfx_steps.get_child(current_step_sfx).play()

		"land":
			sfx_node.get_node("land").play()

		"leapsteps":
			
			if current_leapstep_sfx >= sfx_leapsteps.get_child_count() - 1:
				current_leapstep_sfx = 0
			else:
				current_leapstep_sfx += 1
				
			sfx_leapsteps.get_child(current_leapstep_sfx).play()

		"wallstomp":
			sfx_node.get_node("wall_stomp").play()
			
		"slide":
			sfx_node.get_node("slide").play()
			
		"attack":
			sfx_node.get_node("attack").play()
			
		"2ndattack":
			sfx_node.get_node("2nd_attack").play()
			
