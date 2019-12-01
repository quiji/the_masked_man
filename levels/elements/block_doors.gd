tool
extends StaticBody2D

const OPEN_COLLISION_STATE: Vector2 = Vector2(0.0, -46.0)
const CLOSE_COLLISION_STATE: Vector2 = Vector2(0.0, 0.0)
const CLOSE_SPRITE_STATE: Rect2 = Rect2(0.0, 0.0, 15.0, 52.0)
const OPEN_SPRITE_STATE: Rect2 = Rect2(0.0, 46, 15.0, 6.0)

export (bool) var is_opened = false setget set_is_opened
export (String) var door_owner = ""


func _ready():
	add_to_group("block_doors")
	


	if is_opened:
		$collision.position = OPEN_COLLISION_STATE
		$door.region_rect = OPEN_SPRITE_STATE
	else:
		$collision.position = CLOSE_COLLISION_STATE
		$door.region_rect = CLOSE_SPRITE_STATE


func set_is_opened(is_it:bool) -> void:
	is_opened = is_it
	
	if Engine.editor_hint:
		if is_opened:
			$collision.position = OPEN_COLLISION_STATE
			$door.region_rect = OPEN_SPRITE_STATE
		else:
			$collision.position = CLOSE_COLLISION_STATE
			$door.region_rect = CLOSE_SPRITE_STATE
		

func open_if_owner(is_this: String) -> void:
		
	if door_owner == is_this:
		open()
		
		
func close_if_owner(is_this: String) -> void:
	
	if door_owner == is_this:
		close()
		

func switch_if_owner(is_this: String) -> void:
	
	if door_owner == is_this:
		if is_opened:
			close()
		else:
			open()


func open() -> void:
	if is_opened:
		return
		
	$anims.play("Open")
	is_opened = true

func close() -> void:
	if not is_opened:
		return
		
	$anims.play("Close")
	is_opened = false
