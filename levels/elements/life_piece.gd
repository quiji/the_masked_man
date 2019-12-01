extends Area2D

onready var anims = $anims
onready var visibility_notifier = $visibility_notifier
onready var sfx = $sfx

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
	sfx.connect("finished", self, "_on_sfx_finished")
	
	visibility_notifier.connect("screen_entered", self, "_on_screen_entered")
	
	anims.play("Piece1")

	var state = GameState.get_object_state(get_parent().get_parent().name, get_parent().name + "/" + name)
	if state != null:
		queue_free()
	


func _on_body_entered(player) -> void:
	
	if not visible:
		return
		
	GameState.set_object_state(get_parent().get_parent().name, get_parent().name + "/" + name, true)
	
	GameState.increment_life_pieces()
	GUI.increment_life_pieces()
		
	hide()
	sfx.play()
	
func _on_sfx_finished() -> void:
	queue_free()
	
	
func _on_screen_entered() -> void:

	match GameState.get_life_pieces():
		0:
			anims.play("Piece1")
		1:
			anims.play("Piece2")
		2:
			anims.play("Piece3")
