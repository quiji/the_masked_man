extends CharacterAction

const HIT_FREEZE_TIME: float = 0.2
const KILL_FREEZE_TIME: float = 0.6

var hit_freeze: float = 0.0
var hit_connected: bool 



func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	hit_connected = false
	hit_freeze = 0.0
	actor.swipe_range.enable()

	actor.anims.play("Swipe")

	
func end(new_state: String) -> void:
	actor.swipe_range.disable()
	
func run(delta: float) -> void:
	
	if hit_freeze > 0.0:
		hit_freeze -= delta
		
		if hit_freeze <= 0.0:
			actor.anims.play()

	if actor.anims.current_animation_position > 0.3 and actor.anims.current_animation_position <= 0.5 and not hit_connected:
			
		var fella = actor.swipe_range.get_attacked_fella()
		if fella != null:

			hit_connected = true
			if fella.sword_hit(actor.position, true) > 0:
				hit_freeze = HIT_FREEZE_TIME
				actor.camera.shake(0.2, 3, 0.0, actor.camera.ShakeDirectionTypes.ALL_DIRECTIONS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
			else:
				hit_freeze = KILL_FREEZE_TIME
				actor.camera.shake(0.6, 6, 0.0, actor.camera.ShakeDirectionTypes.ALL_DIRECTIONS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
			actor.anims.stop(false)

	
	if actor.anims.current_animation == "Idle":
		go_to("idle")


