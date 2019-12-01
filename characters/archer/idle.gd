extends CharacterAction


var wait: float

func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	
	actor.anims.play("Idle")
	wait = 0.4
	
func end(new_state: String) -> void:
	pass
	
	
func run(delta: float) -> void:
	
	
	if not actor.is_enemy_on_line_of_sight():
		GUI.close_enemy_health_bar()
		go_to("wait")
		return
	
	
	if actor.enemy != null:
		var direction : Vector2 = actor.enemy.position - actor.position
		direction = direction.normalized()
	
	
		if direction.dot(Vector2(actor.facing, 0)) < 0.0:
			actor.facing = -actor.facing


	if actor.enemy != null and actor.is_enemy_on_line_of_sight() and wait <= 0.0:
		go_to("shoot")
		return
	else:
		wait -= delta
	
	
func handle_input(event: InputEvent):
	pass
	
