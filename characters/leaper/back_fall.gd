extends CharacterAction


var jump_preorder_timer: float
var jump_is_preordered: bool


func install() -> void:
	pass

func start(sub_state: String) -> void:

	
	#actor.anims.play("Fall")
	
	jump_is_preordered = false
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if actor.is_on_ground():
		go_to("roll")
		return

	if actor.is_touching_wall():
		go_to("wall_stomp")
		return


	if jump_is_preordered:
		jump_preorder_timer -= delta
		
	actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
	
	actor.velocity.y = actor.jumps.process(delta)
	
func handle_input(event: InputEvent):
	
	if event.is_action_pressed("jump"):
		jump_is_preordered = true
		jump_preorder_timer = actor.jump_preorder_time

	
