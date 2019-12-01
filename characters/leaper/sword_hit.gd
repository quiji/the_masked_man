extends CharacterAction



var jump_preorder_timer: float
var jump_is_preordered: bool

var falling: bool = false

func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.velocity.y = 0.0
	actor.velocity.x = 0.0
	
	actor.anims.play("SwordHit")
	
	jump_is_preordered = false
	falling = false
	actor.camera.shake(0.2, 3, 0.0, actor.camera.ShakeDirectionTypes.ALL_DIRECTIONS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if actor.anims.current_animation != "SwordHit":

		if falling and not actor.is_on_ground(false):
			go_to("fall")
		elif jump_is_preordered and jump_preorder_timer > 0.0:
			go_to("jump")
		elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			go_to("run")
		else:
			go_to("idle")

		return

	if jump_is_preordered:
		jump_preorder_timer -= delta
		
	if not actor.is_on_ground(false):
		
		if not falling:
			falling = true
			actor.jumps.fall("normal")
		
		actor.velocity.y = actor.jumps.process(delta)
	
	var double_factor: float = 1.0
	if actor.knockback_double:
		double_factor = 4.0
	
	if actor.knockback_direction.x < 0.0:
		actor.velocity.x = lerp(actor.velocity.x, -70.0 * double_factor, Smoothstep.stop4(delta))
	else:
		actor.velocity.x = lerp(actor.velocity.x, 70.0 * double_factor, Smoothstep.stop4(delta))
	
	actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
	
func handle_input(event: InputEvent):
	
	if event.is_action_pressed("jump"):
		jump_is_preordered = true
		jump_preorder_timer = actor.jump_preorder_time
