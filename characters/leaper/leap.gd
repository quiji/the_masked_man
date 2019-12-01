extends CharacterAction


var start_velocity: Vector2
var t: float

var leap_jump_t: float
var leap_jump_duration: float
var sprite_position_backup: Vector2

var leap_speedo: float
var up_leap_speedo: float
var leap_velocity: Vector2
var land_leap_duration: float
var combo: int = 0

var leaped: bool
var is_up_leap: bool
func install() -> void:
	
	
	leap_jump_duration = actor.anims.get_animation("Leap").length
	leap_speedo = actor.leap_distance * 0.9 / leap_jump_duration
	land_leap_duration = actor.anims.get_animation("LandLeap").length
	up_leap_speedo = actor.up_leap_distance * 0.9 / leap_jump_duration
	

func start(sub_state: String) -> void:
	var leap_type := ""

	if states.prev_is("wall_stomp"):
		leap_type = "Up"
		leap_velocity = Vector2(0.0, -up_leap_speedo)
		is_up_leap = true
		actor.camera.shake(0.3, 2, 0.0, actor.camera.ShakeDirectionTypes.X_AXIS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)

	else:
		
		
		
		leap_velocity = Vector2(actor.facing * leap_speedo, 0.0)
		is_up_leap = false
		actor.camera.shake(0.3, 2, 0.0, actor.camera.ShakeDirectionTypes.Y_AXIS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)

	if not actor.is_up_leap_connecting_wall() and leap_type == "Up":
		actor.anims.play("UpLeapToFall")
	elif combo == 0:
		actor.anims.play("Start" + leap_type + "Leap")
	elif combo % 2 == 0:
		actor.anims.play(leap_type + "Leap")
	else:
		actor.anims.play(leap_type + "LeapCombo")
	
	leaped = false
	
	
	t = 0.0
	start_velocity = leap_velocity
	
	leap_jump_t = 0.0

	sprite_position_backup = actor.sprite.position

	combo += 1


	
func end(new_state: String) -> void:
	combo = 0
	actor.sprite.position = sprite_position_backup
	
func run(delta: float) -> void:
	match actor.anims.current_animation:
		"StartLeap", "StartUpLeap":
			return
		"Leap","LeapCombo","UpLeap","UpLeapCombo", "UpLeapToFall":
			if not is_up_leap:
				actor.sprite.position.y = lerp(sprite_position_backup.y, sprite_position_backup.y - 5.0, Smoothstep.bezier7(  0.1, 0.4, 0.5, 0.5, 0.9, 1.0, 2.0, 0.0, leap_jump_t))
			else:
				actor.sprite.position.x = lerp(sprite_position_backup.x, sprite_position_backup.x  - actor.facing * 5.0, Smoothstep.bezier7(  0.1, 0.4, 0.5, 0.5, 0.9, 1.0, 2.0, 0.0, leap_jump_t))


			#0.6
			#if leap_jump_t > 0.7 and Input.is_action_just_pressed("leap") and not leaped:
			#	leaped = true
			
			if  Input.is_action_just_pressed("leap") and not leaped:
				leaped = true

			
			leap_jump_t += delta / leap_jump_duration
			if leap_jump_t > 1.0:
				leap_jump_t = 1.0
				actor.sprite.position = sprite_position_backup
				
				
				if leaped and ( (not is_up_leap and actor.is_on_ground()) or ( is_up_leap and actor.is_touching_wall()) ):
					restart()
			
			#if Input.is_action_pressed("jump") and leap_jump_t > 0.6 and is_up_leap and actor.is_touching_wall(true):
			if Input.is_action_pressed("jump") and is_up_leap and actor.is_touching_wall(true):
				go_to("back_jump")
				return
			
			if Input.is_action_pressed("jump") and leap_jump_t > 0.6 and not is_up_leap and actor.is_on_ground():
				go_to("long_jump")
				return

			
			if not is_up_leap and actor.is_touching_wall():
				go_to("wall_stomp")
				return
		"Fall","JumpPeak":
			go_to("fall")
			return
		"LandLeap":
			
			if not actor.is_on_ground():
				go_to("fall")
				return
			elif Input.is_action_pressed("jump") and t < 0.5 and not is_up_leap and actor.is_on_ground():
				go_to("long_jump")
			elif Input.is_action_pressed("jump") :
				go_to("jump")
			elif Input.is_action_pressed("sword"):
				go_to("attack")
			elif (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"))and t > 0.5:
				go_to("run")

			leap_velocity = start_velocity.linear_interpolate(Vector2(), Smoothstep.stop5(t))
			
			t += delta / land_leap_duration
			if t > 1.0:
				leap_velocity = Vector2()
		_:
			go_to("idle")

	if is_up_leap:
		actor.move_and_slide(leap_velocity, Vector2(0.0, -1.0))
	else:
		#actor.move_and_slide_with_snap(leap_velocity, Vector2(0.0, 20.0), Vector2(0.0, -1.0))
		actor.move_and_slide(leap_velocity, Vector2(0.0, -1.0))
	

	
func handle_input(event: InputEvent):
	pass
	
	
