extends CharacterAction


func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.velocity.y = 0.0
	actor.velocity.x = 0.0
	
	actor.anims.play("SwordHit")
	
	actor.camera.shake(0.2, 3, 0.0, actor.camera.ShakeDirectionTypes.ALL_DIRECTIONS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if actor.anims.current_animation != "SwordHit":
		actor.position = actor.spike_hit_respawn_positon
		go_to("idle")
		return
	
	

func handle_input(event: InputEvent):
	pass
