extends CharacterAction

const HIT_FREEZE_TIME: float = 0.2
const KILL_FREEZE_TIME: float = 0.6

var hit_freeze: float = 0.0
var hit_connected: bool 

var direction : Vector2


var target_position: Vector2
var start_position: Vector2
var t: float = 0.0
var duration: float = 0.6

func install() -> void:
	pass

func start(sub_state: String) -> void:
	

	var closest_point
	var last_distance: float = 10000.0  * 10000.0
	for i in range(actor.leap_points.size()):
		var dist = (actor.leap_points[i] - actor.enemy.position).length_squared()
		if dist < last_distance:
			last_distance = dist
			closest_point = actor.leap_points[i]
		
	
	start_position = actor.position
	target_position = closest_point
	direction = closest_point - actor.position

	direction = direction.normalized()
	
	actor.pierce_range.enable(Vector2( 21.0 * actor.facing, -10))
	
	if direction.dot(Vector2(1, 0)) > 0.0:
		actor.facing = actor.FACE_RIGHT
	else:
		actor.facing = actor.FACE_LEFT
	
	t = 0.0
	hit_connected = false
	hit_freeze = 0.0
	actor.anims.play("StartLeap")
	
func end(new_state: String) -> void:
	actor.pierce_range.disable()

	
func run(delta: float) -> void:
	
	if hit_freeze > 0.0:
		hit_freeze -= delta
		
		if hit_freeze <= 0.0:
			actor.anims.play()

	
	match actor.anims.current_animation:
		"StartLeap":
			pass
		"Leap":
			if t <=  1.0:
				actor.position = start_position.linear_interpolate(target_position, Smoothstep.stop2(t))
			
				t += delta / duration
			else:
				t = 0.0
				start_position = target_position
				target_position += direction * 20.0
				duration = 0.3
				
			if not hit_connected:
				
				var fella = actor.pierce_range.get_attacked_fella()
				if fella != null:
		
					hit_connected = true
					if fella.sword_hit(actor.position) > 0:
						hit_freeze = HIT_FREEZE_TIME
						actor.camera.shake(0.2, 3, 0.0, actor.camera.ShakeDirectionTypes.ALL_DIRECTIONS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
					else:
						hit_freeze = KILL_FREEZE_TIME
						actor.camera.shake(0.6, 6, 0.0, actor.camera.ShakeDirectionTypes.ALL_DIRECTIONS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
					actor.anims.stop(false)
			
				
		"LeapStop":
			if t <=  1.0:
				actor.position = start_position.linear_interpolate(target_position, Smoothstep.start3(t))
			
				t += delta / duration
		"JumpToWall":
			go_to("jump_to_wall")
		"Idle":
			go_to("idle")
			return
	
	

