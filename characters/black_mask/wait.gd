extends CharacterAction



func install() -> void:
	pass

func start(sub_state: String) -> void:
	

	actor.anims.play("Wait")

	
func end(new_state: String) -> void:
	actor.anims.play("WaitToIdle")
	
	
func run(delta: float) -> void:
	pass
