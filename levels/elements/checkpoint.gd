extends Area2D

onready var anims = $anims
onready var arrow_pos = $arrow_pos
onready var sfx = $sfx

# Called when the node enters the scene tree for the first time.
func _ready():
	anims.play("Water")
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(fella):

	if fella.has_method("checkpoint_availible"):
		fella.checkpoint_availible(self)
		GUI.prompt_arrow(arrow_pos)

func _on_body_exited(fella):
	
	if fella.has_method("checkpoint_unavailible"):
		fella.checkpoint_unavailible()
		GUI.unprompt_arrow()
	
	
func water_drank() -> void:
	sfx.play()
	

