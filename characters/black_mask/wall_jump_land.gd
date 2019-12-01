extends CharacterAction





func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	actor.anims.play("WallJumpLand")
	actor.camera.shake(0.4, 4, 0.0, actor.camera.ShakeDirectionTypes.Y_AXIS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)

	

	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if actor.anims.current_animation == "Idle":
		go_to("idle")
	
