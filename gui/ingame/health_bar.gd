tool
extends Control

export (bool) var is_players = true setget set_is_players
export (int) var lives = 1 setget set_lives
export (int) var current_lives = 1


func _ready():
	set_textures()
	update_dots()

func set_is_players(is_it: bool) -> void:
	
	is_players = is_it
	
	if Engine.editor_hint:
		set_textures()
		
func set_textures() -> void:
	if is_players:
		$bar.texture = preload("res://gui/ingame/life_bar.png")
	else:
		$bar.texture = preload("res://gui/ingame/enemy_life_bar.png")

	for i in range($list.get_child_count()):
		var child = $list.get_child(i)
		if child.has_method("set_textures"):
			child.is_players = is_players


func set_lives(how_many: int) -> void:
	lives = how_many
	current_lives = lives
	
	if has_node("bar"):
		update_dots()
		
	
		
func update_dots() -> void:
	var dots : int = 0
	
	for i in range($list.get_child_count()):
		var child = $list.get_child(i)
		if child.has_method("set_textures"):
			if dots < lives:
				child.visible = true
				child.appear(0.4 * (i + 1))
				dots += 1
			else:
				child.visible = false

	#$list.rect_size.x = 24.0 + 17.0 * lives
	#$bar.rect_size.x = 24.0 + 17.0 * lives
	update_sizes()
	
func update_sizes() -> void:
	rect_min_size.x = 24.0 + 17.0 * lives
	rect_min_size.y = 13.0
	rect_size = rect_min_size
	
	"""
	$list.rect_min_size.x = 24.0 + 17.0 * lives
	$list.rect_size.x =$list.rect_min_size.x
	$bar.rect_min_size = $list.rect_size
	$bar.rect_size = $bar.rect_min_size
	$bar.rect_size.y = 13
	rect_min_size  = $bar.rect_size
	rect_size  = $bar.rect_size
	"""
	
func full_heal() -> void:
	current_lives = lives
	for i in range(lives):
		$list.get_child(i + 1).appear(0.1 * i)

func life_down(disappear_on_empty:bool = false) -> int:
	
	if current_lives > 0:
		$list.get_child(current_lives).disappear()
		current_lives -= 1
	
	
	if disappear_on_empty and current_lives <= 0:
		hide()

	
	return current_lives
	
func increment_max_life() -> Vector2:
	lives += 1
	
	$list.get_child(lives).extend_simple()
	current_lives += 1
	$list.get_child(current_lives).appear(1.0)
	
	update_sizes()
	
	return $list.get_child(current_lives).dot.global_position
	



