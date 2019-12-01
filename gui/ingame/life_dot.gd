tool
extends Control

onready var dot = $dot

export (bool) var is_players = true setget set_is_players 


func _ready():
	set_textures()
	$delay_timer.connect("timeout", self, "_on_delay_timeout")
	

func set_is_players(is_it: bool) -> void:
	
	is_players = is_it
	
	if has_node("back_dot"):
		set_textures()

func set_textures() -> void:
	if is_players:
		$back_dot.texture = preload("res://gui/ingame/life_dot.png")
		$dot.texture = preload("res://gui/ingame/life_dot.png")
	else:
		$back_dot.texture = preload("res://gui/ingame/enemy_life_dot.png")
		$dot.texture = preload("res://gui/ingame/enemy_life_dot.png")

func appear(delay: float = -1) -> void:
	if delay > 0.0:
		$dot.visible = false
		$delay_timer.start(delay)
	else:
		$anims.play("appear")
	
func disappear() -> void:
	if not $delay_timer.is_stopped():
		$delay_timer.stop()
	$anims.play("disappear")
	
func extend_simple() -> void:
	$dot.visible = false
	visible = true

func _on_delay_timeout() -> void:

	$anims.play("appear")


