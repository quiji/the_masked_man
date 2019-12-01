tool
extends Area2D

const SPIKES_WIDTH: float = 16.0

export (float) var length = 16 setget set_length
export (bool) var is_down = true setget set_is_down
var respawner = null

func _ready():
	add_to_group("spikes")
	$collision.shape = $collision.shape.duplicate()
	
	$spikes_down.rect_size.x = length
	$spikes_down.rect_position.x = -length / 2.0
	$spikes_up.rect_size.x = length
	$spikes_up.rect_position.x = -length / 2.0
	$collision.shape.extents.x = length / 2.0

	connect("body_entered", self, "_on_player_hit")

func set_length(new_len: float) -> void:
	length = new_len
	
	if Engine.editor_hint:
		$spikes_down.rect_size.x = length
		$spikes_down.rect_position.x = -length / 2.0
		$spikes_up.rect_size.x = length
		$spikes_up.rect_position.x = -length / 2.0
		$collision.shape.extents.x = length / 2.0

func set_is_down(is_it: bool) -> void:
	is_down = is_it
	
	if has_node("spikes_down"):
		$spikes_down.visible = is_down
		$spikes_up.visible = not is_down
	

func _on_player_hit(player) -> void:
	
	var respawn_pos: Vector2 = Vector2()
	if respawner != null:
		respawn_pos = respawner.position
	
	player.spike_hit(respawn_pos)



func set_current_respawn(who) -> void:
	respawner = who
