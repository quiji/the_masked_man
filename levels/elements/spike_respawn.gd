extends Area2D



func _ready():
	connect("body_entered", self, "_on_player_registered")
	


func _on_player_registered(player):
	get_tree().call_group("spikes", "set_current_respawn", self)
	

