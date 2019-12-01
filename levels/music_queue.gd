extends Area2D

export (int) var tune_to_play
export (bool) var is_stop_cue = false

func _ready():
	
	
	
	connect("body_entered", self, "_on_body_entered")



func _on_body_entered(fella) -> void:
	if not is_stop_cue:
		Maestro.play(tune_to_play)
	else:
		Maestro.stop(tune_to_play)
		


