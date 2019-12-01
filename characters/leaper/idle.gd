extends CharacterAction

var start_speed: float
var end_speed: float
var t: float


func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	if states.prev_is("run") and abs(actor.velocity.x) == actor.run_speed:
		actor.anims.play("RunStop")

		if actor.velocity.x != 0.0:
	
			start_speed = actor.velocity.x
			end_speed = 0.0
			t = 0.0
		else:
			t = 1.1
			
	elif states.prev_is("fall"):
		actor.anims.play("Land")
		t = 1.1
		
	else:
		actor.anims.play("Idle")
		t = 1.1
		actor.velocity.x = 0.0
	
	actor.velocity.y = 0.0
	
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if not actor.is_on_ground():
		go_to("fall")
		return
	
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		go_to("run")
		return
		
	if t <= 1.0:
		#actor.velocity.x = lerp(start_speed, end_speed, Smoothstep.start2(t))
		actor.velocity.x = lerp(start_speed, end_speed, Smoothstep.stop3(t))
		t += delta / actor.time_to_stop_run
	
		if t > 1.0:
			actor.velocity.x = end_speed
		
		#actor.move_and_slide_with_snap(actor.velocity, Vector2(0.0, 20.0), Vector2(0.0, -1.0))
		actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
	
	
func handle_input(event: InputEvent):
	
	if event.is_action_pressed("jump"):
		go_to("jump")

	if event.is_action_pressed("leap"):
		go_to("leap")

	if event.is_action_pressed("ui_down") and actor.checkpoint != null:
		actor.register_checkpoint()
		
		
	if event.is_action_pressed("sword"):
		go_to("attack")
		
		
