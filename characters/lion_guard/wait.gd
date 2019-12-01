extends CharacterAction


func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	if not states.prev_is("sword_idle"):
		actor.anims.play("Idle")
	
	
func end(new_state: String) -> void:
	actor.anims.play("DrawSword")
	GUI.open_enemy_health_bar(actor.lives)
	
func run(delta: float) -> void:
	
	if actor.enemy != null and actor.is_enemy_on_line_of_sight():
		go_to("sword_idle")
	
func handle_input(event: InputEvent):
	pass
	
