extends CharacterAction



func install() -> void:
	pass

func start(sub_state: String) -> void:
	

	actor.anims.play("SwordDeath")
	actor.collision.disabled = true

func end(new_state: String) -> void:
	pass
	
	
func run(delta: float) -> void:
	
	if not actor.anims.is_playing():
		GUI.hide()
		SceneSwitcher.change_scene("res://gui/screens/end_screen.tscn")
		
		actor.set_process(false)
		return
	
	
func handle_input(event: InputEvent):
	pass
	
