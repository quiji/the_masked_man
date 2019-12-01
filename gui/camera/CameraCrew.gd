extends Node2D

class_name CameraCrew

const LAST_COLLISION_LAYER: int = 524288
const CAMERA_MOVE_FACTOR: float = 10.0
const CAMERA_SLOWER_MOVE_FACTOR: float = 5.0
const CAMERA_X_MIN_SLOWDOWN_DISTANCE: float = 20.0
const CAMERA_Y_MIN_SLOWDOWN_DISTANCE: float = 280.0


onready var extents: Vector2 = Vector2(ProjectSettings.get("display/window/size/width") * 0.5, ProjectSettings.get("display/window/size/height") * 0.5)


export (NodePath) var actor_node

var camera_man = null
var actor = null

var last_area_collider = null
var limit_top: int
var limit_bottom: int
var limit_left: int
var limit_right: int

var are_we_forcing_update: bool = false

func _ready():
	
	if actor_node:
		actor = get_node(actor_node)
	
	for i in range(get_child_count()):
		var child = get_child(i)
		
		if child is CameraMan:
			camera_man = child

func force_update() -> void:
	if actor != null:
		are_we_forcing_update = true


func _physics_process(delta) -> void:
	
	if actor == null:
		return

	var space_state = get_world_2d().direct_space_state
	var areas = space_state.intersect_point(actor.global_position, 4, [], LAST_COLLISION_LAYER, false, true)
	
	
	var current_limits: int 
	var last_priority: int = 100
	for i in range(areas.size()):
		if areas[i].collider.box_priority < last_priority:
			last_priority = areas[i].collider.box_priority
			current_limits = i
		
	if current_limits < areas.size() and areas[current_limits].collider != last_area_collider:
		last_area_collider = areas[current_limits].collider
		limit_top = areas[current_limits].collider.limit_top
		limit_bottom = areas[current_limits].collider.limit_bottom
		limit_left = areas[current_limits].collider.limit_left
		limit_right = areas[current_limits].collider.limit_right



	
	var target: Vector2

	var camera_bounds: Rect2 = Rect2(position - extents,  2.0* extents) 
	var target_bounds: Rect2 = Rect2(actor.position - extents, 2.0*extents) 
	var full_limit_distance_x: float = abs(limit_left) + abs(limit_right)
	var full_limit_distance_y: float = abs(limit_top) + abs(limit_bottom)
	
	if (camera_bounds.position.x < limit_left or camera_bounds.end.x > limit_right) and extents.x * 2.0 > full_limit_distance_x  :
		target.x = last_area_collider.position.x

	elif target_bounds.position.x < limit_left:
		target.x = limit_left + extents.x
		
	elif target_bounds.end.x > limit_right:
		target.x = limit_right - extents.x
		
	else:
		target.x = actor.position.x
		
	
	if (camera_bounds.position.y < limit_top or camera_bounds.end.y > limit_bottom) and extents.y * 2.0 > full_limit_distance_y:
		target.y = last_area_collider.position.y
		

	elif target_bounds.position.y < limit_top:
		target.y = limit_top + extents.y
		

	elif target_bounds.end.y > limit_bottom:
		target.y = limit_bottom - extents.y
		
	else:
		target.y = actor.position.y


	if are_we_forcing_update:
		are_we_forcing_update = false
		position = target
	else:
		var direction :Vector2 = target - position
	
		var factor: float = CAMERA_MOVE_FACTOR
	
		if abs(target.x - position.x) > CAMERA_X_MIN_SLOWDOWN_DISTANCE:
			factor = CAMERA_SLOWER_MOVE_FACTOR
	
		position.x = lerp(position.x, target.x, delta * factor)
	
		factor = CAMERA_MOVE_FACTOR
		if abs(target.y - position.y) > CAMERA_Y_MIN_SLOWDOWN_DISTANCE:
			factor = CAMERA_SLOWER_MOVE_FACTOR
	
		position.y = lerp(position.y, target.y, delta * factor)
		
