extends KinematicBody2D

const OBSTACLE_COLLISION_BIT: int = 1

onready var guard_vision = $guard_vision
onready var states = $states
onready var anims = $anims
onready var sprite = $guard
onready var collision = $collision
onready var sfx_node = $sfx


const FACE_RIGHT: float = 1.0
const FACE_LEFT: float = -1.0


export (bool) var block_doors = false
export (bool) var face_left = true
export (int) var lives = 4

var enemy = null
var enemy_sighted : Dictionary
var facing: float = 0.0 setget set_facing
var velocity: Vector2
var knockback_direction: Vector2


func _ready():
	guard_vision.connect("body_entered", self, "_on_player_entered")
	
	if face_left:
		facing = FACE_LEFT
	else:
		facing = FACE_RIGHT

func set_facing(is_it: float) -> void:
	if facing == is_it:
		return
		
	facing = is_it
	sprite.flip_h = FACE_RIGHT == facing

func _on_player_entered(player) -> void:
	if enemy == null:
		enemy = player
		if block_doors:
			get_tree().call_group("block_doors", "close_if_owner", name)
	
		#states.set_next("sword_idle")
		

func _process(delta):
	
	if enemy != null:
		var space_state = get_world_2d().direct_space_state
		enemy_sighted = space_state.intersect_ray(global_position + Vector2(0, -10.0), enemy.global_position + Vector2(0, -10.0), [self], OBSTACLE_COLLISION_BIT)
	
	states.run(delta)

func hit(attacker_position) -> int:
	knockback_direction = attacker_position - position
	knockback_direction = -knockback_direction.normalized()

	sfx_node.get_node("sword_hit").play()

	var current_lives: int = GUI.enemy_life_down()
	if current_lives > 0:
		if states.current_is("hit"):

			states.current.restart()
		else:
			states.set_next("hit")
	else:
		states.set_next("sword_death")
	
		if block_doors:
			get_tree().call_group("block_doors", "open_if_owner", name)
			
	
	return current_lives
	
	
func is_enemy_on_line_of_sight() -> bool:
	return not enemy_sighted.empty() and enemy_sighted.collider.has_method("is_up_leap_connecting_wall")
	


func sfx(type: String) -> void:

	match type:
			
		"attack":
			sfx_node.get_node("attack").play()
			
		"2ndattack":
			sfx_node.get_node("2nd_attack").play()
			
