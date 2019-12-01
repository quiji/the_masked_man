extends CharacterAction

var start_speed: float
var end_speed: float
var t: float

var last_facing: float

var jump_preorder_timer: float
var jump_is_preordered: bool


func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	if states.prev_is("leap"):
		actor.jumps.fall("normal", actor.velocity.y)
	elif not states.prev_is("jump"):
		actor.velocity.y = 0.0
		actor.jumps.fall("normal")
	
	if actor.anims.current_animation != "JumpPeak":
		actor.anims.play("Fall")
	
	
	
	t = 1.1
	if Input.is_action_pressed("ui_left"):
		start_speed = actor.velocity.x
		end_speed = -actor.run_speed
		t = 0.0

		actor.facing = actor.FACE_LEFT
		last_facing = actor.FACE_LEFT

	elif Input.is_action_pressed("ui_right"):
		start_speed = actor.velocity.x
		end_speed = actor.run_speed
		t = 0.0

		actor.facing = actor.FACE_RIGHT
		last_facing = actor.FACE_RIGHT
	else:
		start_speed = actor.velocity.x
		end_speed = 0.0
		t = 0.0
		
		last_facing = 0.0
		
	
	
	jump_is_preordered = false
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if actor.is_on_ground():
		if jump_is_preordered and jump_preorder_timer > 0.0:
			go_to("jump")
		elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			go_to("run")
		else:
			go_to("idle")
		return
	

	if actor.is_ledge_availible() and ((Input.is_action_pressed("ui_left") and actor.facing == actor.FACE_LEFT) or (Input.is_action_pressed("ui_right") and actor.facing == actor.FACE_RIGHT)):
		go_to("ledge_hang")
		return


	
	if Input.is_action_pressed("ui_left") and last_facing != actor.FACE_LEFT:
		start_speed = actor.velocity.x
		end_speed = -actor.run_speed
		t = 0.0

		actor.facing = actor.FACE_LEFT
		last_facing = actor.FACE_LEFT
	elif Input.is_action_pressed("ui_right") and last_facing != actor.FACE_RIGHT:
		start_speed = actor.velocity.x
		end_speed = actor.run_speed
		t = 0.0

		actor.facing = actor.FACE_RIGHT
		last_facing = actor.FACE_RIGHT
	elif actor.velocity.x != 0.0 and t > 1.0 and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		start_speed = actor.velocity.x
		end_speed = 0.0
		t = 0.0
		
		last_facing = 0.0

	if t <= 1.0:
		actor.velocity.x = lerp(start_speed, end_speed, Smoothstep.stop2(t))
		t += delta / actor.time_to_move_midair
	
		if t > 1.0:
			actor.velocity.x = end_speed

	if jump_is_preordered:
		jump_preorder_timer -= delta
		
	actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
	
	actor.velocity.y = actor.jumps.process(delta)
	
func handle_input(event: InputEvent):
	
	if event.is_action_pressed("jump"):
		jump_is_preordered = true
		jump_preorder_timer = actor.jump_preorder_time

	
