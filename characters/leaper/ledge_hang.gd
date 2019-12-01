extends CharacterAction

var hang_facing: float

func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.velocity.y = 0.0
	actor.velocity.x = 0.0 


	hang_facing = actor.facing
	actor.anims.play("LedgeHang")
	
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
			
	if (Input.is_action_just_released("ui_left") and hang_facing == actor.FACE_LEFT) or (Input.is_action_just_released("ui_right") and hang_facing == actor.FACE_RIGHT):
		go_to("fall")
		return

	
	
func handle_input(event: InputEvent):

	if event.is_action_pressed("jump"):
		go_to("jump")
