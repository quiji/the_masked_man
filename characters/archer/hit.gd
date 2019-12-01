extends CharacterAction




func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	actor.anims.play("Hit")
		
	actor.velocity.x = 0.0

func end(new_state: String) -> void:
	pass
	
	
func run(delta: float) -> void:
	if  actor.anims.current_animation != "Hit":
		go_to("idle")
		return
	
	
	if actor.knockback_direction.x < 0.0:
		actor.velocity.x = lerp(actor.velocity.x, -70.0, Smoothstep.stop4(delta))
	else:
		actor.velocity.x = lerp(actor.velocity.x, 70.0, Smoothstep.stop4(delta))
		

	actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
	
func handle_input(event: InputEvent):
	pass
	
