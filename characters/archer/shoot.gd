extends CharacterAction


func install() -> void:
	pass

func start(sub_state: String) -> void:
	actor.velocity.y = 0.0
	actor.velocity.x = 0.0
	
	actor.anims.play("Shoot")
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if not actor.is_enemy_on_line_of_sight() or actor.anims.current_animation == "Idle":
		go_to("idle")
		return
		


		

func handle_input(event: InputEvent):
	pass
	
