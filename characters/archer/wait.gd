extends CharacterAction


func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	
	actor.anims.play("Idle")
	
	
func end(new_state: String) -> void:
	GUI.open_enemy_health_bar(actor.lives)
	
	
func run(delta: float) -> void:
	
	if actor.enemy != null and actor.is_enemy_on_line_of_sight():
		go_to("idle")
		return

	
func handle_input(event: InputEvent):
	pass
	
