extends CharacterAction

var start_speed: float
var end_speed: float
var t: float

var last_facing: float
var ledge_hand_delay: float = 0.0

func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	actor.velocity.y = actor.jumps.start("normal")
	
	if states.prev_is("ledge_hang"):
		ledge_hand_delay = 0.4
	else:
		ledge_hand_delay = 0.0
	
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
	
	actor.anims.play("Jump")
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if actor.jumps.reached_peak():
		go_to("fall")
		return

	if ledge_hand_delay <= 0.0 and actor.is_ledge_availible() and ((Input.is_action_pressed("ui_left") and actor.facing == actor.FACE_LEFT) or (Input.is_action_pressed("ui_right") and actor.facing == actor.FACE_RIGHT)):
		go_to("ledge_hang")
		return

	if ledge_hand_delay > 0.0:
		ledge_hand_delay -= delta

	if actor.jumps.reaching_peak(0.1) and actor.anims.current_animation == "Jump":
		actor.anims.play("JumpPeak")
	
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

		
		
	actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
	
	actor.velocity.y = actor.jumps.process(delta)
	
func handle_input(event: InputEvent):
	
	if event.is_action_released("jump"):
		actor.jumps.interrupt(0.3)
	
