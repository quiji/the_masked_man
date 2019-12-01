extends CharacterAction



func install() -> void:
	pass

func start(sub_state: String) -> void:
	actor.velocity.y = 0.0
	actor.velocity.x = 0.0
	
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if not actor.is_enemy_on_line_of_sight():
		GUI.close_enemy_health_bar()
		actor.anims.play_backwards("DrawSword")
		actor.anims.queue("Idle")
		go_to("wait")
		return
	
	var direction : Vector2 = actor.enemy.position - actor.position
	var distance: float = direction.length()
	direction = direction.normalized()
	
	if direction.dot(Vector2(actor.facing, 0)) < 0.0:
		actor.facing = -actor.facing
	
	# Attack Range
	#if distance < 30.0:
	#if distance < 35.0:
	if distance < 45.0:
		
		#if actor.enemy.is_attacking():
		#	pass
		#else:
		go_to("attack")

		

func handle_input(event: InputEvent):
	pass
	
