extends CharacterAction

func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	actor.facing = -actor.facing
	
	actor.velocity.y = actor.jumps.start("back_jump")
	actor.velocity.x = actor.facing * actor.jumps.get_run_speedo("back_jump")
	
	#t = 1.1
	actor.anims.play("BackJump")
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if actor.jumps.reached_peak():
		go_to("back_fall")
		return


	if actor.is_touching_wall():
		go_to("wall_stomp")
		return


	if actor.jumps.reaching_peak(0.1) and actor.anims.current_animation == "Jump":
		actor.anims.play("JumpPeak")
		
		
	actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
	
	actor.velocity.y = actor.jumps.process(delta)
	
func handle_input(event: InputEvent):
	pass
	#if event.is_action_released("jump"):
	#	actor.jumps.interrupt(0.3)
	
