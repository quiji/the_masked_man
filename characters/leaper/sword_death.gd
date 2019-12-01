extends CharacterAction



var jump_preorder_timer: float
var jump_is_preordered: bool

var falling: bool = false

func install() -> void:
	pass

func start(sub_state: String) -> void:

	actor.velocity.y = 0.0
	actor.velocity.x = 0.0
	
	actor.anims.play("SwordDeath")
	
	actor.camera.shake(0.6, 6, 0.0, actor.camera.ShakeDirectionTypes.ALL_DIRECTIONS, actor.camera.ShakeMovementTypes.STRONG_TO_LOW)
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if not actor.anims.is_playing():
		GameState.spawn()
		return

	if actor.knockback_direction.x < 0.0:
		actor.velocity.x = lerp(actor.velocity.x, -2.0, Smoothstep.stop4(delta))
	else:
		actor.velocity.x = lerp(actor.velocity.x, 2.0, Smoothstep.stop4(delta))
	
	actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
	
func handle_input(event: InputEvent):
	pass
