tool
extends Area2D

const SPIKES_WIDTH: float = 16.0

export (float) var length = 16 setget set_length
export (bool) var is_right = true setget set_is_right

var respawner = null

func _ready():
	add_to_group("spikes")
	$collision.shape = $collision.shape.duplicate()
	
	$spikes_right.rect_size.y = length
	$spikes_right.rect_position.y = -length / 2.0
	$spikes_left.rect_size.y = length
	$spikes_left.rect_position.y = -length / 2.0
	$collision.shape.extents.y = length / 2.0

	connect("body_entered", self, "_on_player_hit")

func set_length(new_len: float) -> void:
	length = new_len
	
	if Engine.editor_hint:
		$spikes_right.rect_size.y = length
		$spikes_right.rect_position.y = -length / 2.0
		$spikes_left.rect_size.y = length
		$spikes_left.rect_position.y = -length / 2.0
		$collision.shape.extents.y = length / 2.0

func set_is_right(is_it: bool) -> void:
	is_right = is_it
	
	if has_node("spikes_right"):
		$spikes_right.visible = is_right
		$spikes_left.visible = not is_right


func _on_player_hit(player) -> void:
	
	var respawn_pos: Vector2 = Vector2()
	if respawner != null:
		respawn_pos = respawner.position
	
	player.spike_hit(respawn_pos)



func set_current_respawn(who) -> void:
	respawner = who
