extends CharacterAction



var jump_preorder_timer: float
var jump_is_preordered: bool

var falling: bool = false


var hit_connected: bool = false

var hit_freeze: float = 0.0
const HIT_FREEZE_TIME: float = 0.2
const KILL_FREEZE_TIME: float = 0.6

var second_attacked_queued: bool = false

func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.velocity.y = 0.0
	
	actor.attack_range.enable(Vector2( 6.0 * actor.facing, -10))
	
	actor.anims.play("Attack")
	jump_is_preordered = false
	falling = false
	hit_connected = false
	
	hit_freeze = 0.0
	second_attacked_queued = false
	
func end(new_state: String) -> void:
	actor.attack_range.disable()

	
func run(delta: float) -> void:
	
	if hit_freeze > 0.0:
		hit_freeze -= delta
		
		if hit_freeze <= 0.0:
			if second_attacked_queued:
				go_to("2nd_attack")
				return
			else:
				actor.anims.play()

	
	#if actor.anims.current_animation != "Attack":
	if not actor.anims.is_playing() and hit_freeze <= 0.0:

		if jump_is_preordered and jump_preorder_timer > 0.0:
			go_to("jump")
		elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			go_to("run")
		else:
			go_to("idle")

		return

	if jump_is_preordered:
		jump_preorder_timer -= delta
		
	
	actor.velocity.x = lerp(actor.velocity.x, actor.facing * 80.0, delta)
	actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
	
	if actor.anims.current_animation_position > 0.2 and not hit_connected:# and actor.anims.current_animation_position <= 0.3:
		
		var fella = actor.attack_range.get_attacked_fella()
		if fella != null:

			hit_connected = true
			if fella.hit(actor.position) > 0:
				hit_freeze = HIT_FREEZE_TIME
				actor.camera.shake(0.2, 3, 0.0, actor.camera.ShakeDirectionTypes.ALL_DIRECTIONS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
			else:
				hit_freeze = KILL_FREEZE_TIME
				actor.camera.shake(0.6, 6, 0.0, actor.camera.ShakeDirectionTypes.ALL_DIRECTIONS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
			actor.anims.stop(false)
	
func handle_input(event: InputEvent):
	
	if event.is_action_pressed("jump"):
		jump_is_preordered = true
		jump_preorder_timer = actor.jump_preorder_time

	
	if event.is_action_pressed("sword"):
		if actor.anims.current_animation_position > 0.2:# and actor.anims.current_animation_position <= 0.3:
			if hit_freeze > 0.0:
				second_attacked_queued = true
			else:
				go_to("2nd_attack")
	
