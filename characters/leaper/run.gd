extends CharacterAction

# Leap time position == 0.15 - 0.3  |  0.85 - 1.0
# 0.15 secs for reaction 



var start_speed: float
var end_speed: float
var t: float
var last_facing: float

var is_turning: bool


func is_valid_leap() -> bool:
	return (actor.anims.current_animation_position >= 0.15 and actor.anims.current_animation_position <= 0.3 ) or (actor.anims.current_animation_position >= 0.85 and actor.anims.current_animation_position <= 1.0 )

func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	if states.prev_is("fall"):
		actor.anims.play("LandToRun")
	elif actor.anims.current_animation == "RunStop":
		actor.anims.play("RunTurn")
	else:
		actor.anims.play("Run")
	
	if Input.is_action_pressed("ui_left"):
		actor.facing = actor.FACE_LEFT

	elif Input.is_action_pressed("ui_right"):
		actor.facing = actor.FACE_RIGHT
	

	start_speed = actor.velocity.x
	end_speed = actor.facing * actor.run_speed
	t = 0.0
	last_facing = actor.facing
	is_turning = false
	
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if not actor.is_on_ground():
		go_to("fall")
		return

	if Input.is_action_pressed("ui_left"):
		actor.facing = actor.FACE_LEFT
		
	elif Input.is_action_pressed("ui_right"):
		actor.facing = actor.FACE_RIGHT
	else:
		go_to("idle")
		return
	
	if last_facing != actor.facing:
		actor.anims.play("RunStopTurn")
		start_speed = actor.velocity.x
		end_speed = actor.facing * actor.run_speed
		t = 0.0
		last_facing = actor.facing
		is_turning = true

	if t <= 1.0:
		if is_turning:
			#actor.velocity.x = lerp(start_speed, end_speed, Smoothstep.start2(t))
			actor.velocity.x = lerp(start_speed, end_speed, Smoothstep.stop3(t))
		else:
			actor.velocity.x = lerp(start_speed, end_speed, Smoothstep.stop4(t))
		t += delta / actor.time_to_top_run_speed
	
		if t > 1.0:
			actor.velocity.x = end_speed
	
	actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
	#actor.move_and_slide_with_snap(actor.velocity, Vector2(0.0, 20.0), Vector2(0.0, -1.0))
	
func handle_input(event: InputEvent):
	
	if event.is_action_pressed("jump"):
		go_to("jump")

	if event.is_action_pressed("leap"):
		go_to("leap")

	if event.is_action_pressed("sword"):
		go_to("attack")
