extends Area2D

var respawner = null

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("spikes")

	connect("body_entered", self, "_on_player_hit")
	
	
func _on_player_hit(player) -> void:
	
	var respawn_pos: Vector2 = Vector2()
	if respawner != null:
		respawn_pos = respawner.position
	
	player.spike_hit(respawn_pos)



func set_current_respawn(who) -> void:
	respawner = who
