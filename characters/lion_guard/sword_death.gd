extends CharacterAction



func install() -> void:
	pass

func start(sub_state: String) -> void:
	

	actor.anims.play("SwordDeath")
	actor.velocity.x = 0.0

func end(new_state: String) -> void:
	pass
	
	
func run(delta: float) -> void:
	
	if not actor.anims.is_playing():
		actor.guard_vision.monitoring = false
		actor.collision.disabled = true
		actor.set_process(false)
		return
	
	if actor.knockback_direction.x < 0.0:
		actor.velocity.x = lerp(actor.velocity.x, -60.0, Smoothstep.stop4(delta))
	else:
		actor.velocity.x = lerp(actor.velocity.x, 60.0, Smoothstep.stop4(delta))

	actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
	
func handle_input(event: InputEvent):
	pass
	
