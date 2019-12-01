extends CharacterAction


var jump_preorder_timer: float
var jump_is_preordered: bool

var falling: bool = false
var timer: float = 0.0

func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.velocity.y = 0.0
	actor.velocity.x *= 0.5
	
	timer = 0.0
	
	actor.anims.play("Roll")
	
	jump_is_preordered = false
	falling = false
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if actor.anims.current_animation != "Roll":

		if falling and not actor.is_on_ground(false):
			go_to("fall")
		elif jump_is_preordered and jump_preorder_timer > 0.0:
			go_to("jump")
		elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			go_to("run")
		else:
			go_to("idle")

		return

	timer += delta

	if jump_is_preordered:
		jump_preorder_timer -= delta
		
	if not actor.is_on_ground(false):
		
		if not falling:
			falling = true
			actor.jumps.fall("normal")
		
		actor.velocity.y = actor.jumps.process(delta)
		
	actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
	
func handle_input(event: InputEvent):
	
	if event.is_action_pressed("jump"):
		jump_is_preordered = true
		jump_preorder_timer = actor.jump_preorder_time

	if event.is_action_pressed("leap") and timer > 0.3 and actor.is_on_ground():
		if Input.is_action_pressed("ui_left"):
			actor.facing = actor.FACE_LEFT
		elif Input.is_action_pressed("ui_right"):
			actor.facing = actor.FACE_RIGHT
			
		go_to("leap")
		
