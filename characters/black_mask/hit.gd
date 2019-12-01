extends CharacterAction




func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	actor.anims.play("Hit")
		
	

func end(new_state: String) -> void:
	pass
	
	
func run(delta: float) -> void:
	if  actor.anims.current_animation != "Hit":
		go_to("idle")
		return
	
	
func handle_input(event: InputEvent):
	pass
	
