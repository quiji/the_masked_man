extends CharacterAction

const HIT_FREEZE_TIME: float = 0.2
const KILL_FREEZE_TIME: float = 0.6

var hit_freeze: float = 0.0
var hit_connected: bool 


var start_position: Vector2
var end_position: Vector2
var duration: float = 1.0
var t: float = 0.0

var hold_position_timer: float

func install() -> void:
	pass

func start(sub_state: String) -> void:
	

	actor.anims.play("WallHold")
	hold_position_timer = 0.8
	actor.facing *= -1.0

	hit_connected = false
	hit_freeze = 0.0
	actor.lancer_range.enable(Vector2( 7.0 * actor.facing, -7.0))

		
func end(new_state: String) -> void:
	actor.lancer_range.disable()
	
	
	
func run(delta: float) -> void:
	
	if hit_freeze > 0.0:
		hit_freeze -= delta
		
		if hit_freeze <= 0.0:
			actor.anims.play()

	
	if hold_position_timer > 0.0:
		hold_position_timer -= delta
		
		if hold_position_timer <= 0.0:
			actor.anims.play("WallJump")
			
			t = 0.0
			
			start_position = actor.position
			
			if actor.enemy.position.x >= actor.leap_points[0].x and actor.enemy.position.x  <= actor.leap_points[1].x:

				end_position.y = actor.leap_points[0].y
				end_position.x = actor.enemy.position.x

			else:
				end_position.y = actor.leap_points[0].y
				end_position.x = actor.leap_points[0].x + actor.leap_points[1].x

			
		else:
			return
	
	if t <= 1.0:
		actor.position.x = lerp(start_position.x, end_position.x, Smoothstep.stop2(t))
		actor.position.y = lerp(start_position.y, end_position.y, Smoothstep.start6(t))

		if actor.anims.current_animation_position >= 0.7 and not hit_connected:
				
			var fella = actor.lancer_range.get_attacked_fella()
			if fella != null:
	
				hit_connected = true
				if fella.sword_hit(actor.position) > 0:
					hit_freeze = HIT_FREEZE_TIME
					actor.camera.shake(0.2, 3, 0.0, actor.camera.ShakeDirectionTypes.ALL_DIRECTIONS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
				else:
					hit_freeze = KILL_FREEZE_TIME
					actor.camera.shake(0.6, 6, 0.0, actor.camera.ShakeDirectionTypes.ALL_DIRECTIONS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
				actor.anims.stop(false)
		
		t += delta / duration
	else:
		if  not hit_connected:
				
			var fella = actor.lancer_range.get_attacked_fella()
			if fella != null:
	
				hit_connected = true
				if fella.sword_hit(actor.position) > 0:
					hit_freeze = HIT_FREEZE_TIME
					actor.camera.shake(0.2, 3, 0.0, actor.camera.ShakeDirectionTypes.ALL_DIRECTIONS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
				else:
					hit_freeze = KILL_FREEZE_TIME
					actor.camera.shake(0.6, 6, 0.0, actor.camera.ShakeDirectionTypes.ALL_DIRECTIONS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
				actor.anims.stop(false)
		
		go_to("wall_jump_land")

