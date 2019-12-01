extends CharacterAction



func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.velocity.y = 0.0
	actor.velocity.x = 0.0 

	if states.prev_is("leap"):
		actor.camera.shake(0.3, 4, 0.0, actor.camera.ShakeDirectionTypes.X_AXIS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
	else:
		actor.camera.shake(0.5, 6, 0.0, actor.camera.ShakeDirectionTypes.X_AXIS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
	

	actor.anims.play("WallStomp")
	
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	if actor.anims.current_animation != "WallStomp":
		go_to("fall")
		return
		
		

	
	
func handle_input(event: InputEvent):

	if event.is_action_pressed("leap"):
		go_to("leap")
