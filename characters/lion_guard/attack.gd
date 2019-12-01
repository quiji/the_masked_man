extends CharacterAction

var hit_connected: bool
var second_hit_connected: bool
var attack_shape: CapsuleShape2D

var hit_freeze: float = 0.0
const HIT_FREEZE_TIME: float = 0.2
const KILL_FREEZE_TIME: float = 0.6

func install() -> void:
	attack_shape = CapsuleShape2D.new()
	attack_shape.height = 8.0
	attack_shape.radius = 12.0


func start(sub_state: String) -> void:
	actor.anims.play("Attack")
	hit_connected = false
	second_hit_connected = false
	hit_freeze = 0.0
	actor.velocity.y = 0.0
	
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if hit_freeze > 0.0:
		hit_freeze -= delta
		
		if hit_freeze <= 0.0:
			actor.anims.play()
	
	match actor.anims.current_animation:
		"Attack":
			actor.velocity.x = lerp(actor.velocity.x, actor.facing * 20.0, delta)
			actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
			if actor.anims.current_animation_position > 0.4 and actor.anims.current_animation_position < 0.6 and not hit_connected:
				
				var space_state = get_parent().get_parent().get_world_2d().direct_space_state
				var query = Physics2DShapeQueryParameters.new()
				query.collision_layer = 2
				query.transform = actor.transform.translated(Vector2(actor.facing * 7, -16))
				query.set_shape(attack_shape)
				var result = space_state.intersect_shape(query, 1)
				if result.size() > 0:
					hit_connected = true
					if result[0].collider.sword_hit(actor.position) > 0:
						hit_freeze = HIT_FREEZE_TIME
					else:
						hit_freeze = KILL_FREEZE_TIME
					actor.anims.stop(false)
					

		"2ndAttack":
			actor.velocity.x = lerp(actor.velocity.x, 0.0, delta)
			actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
			if actor.anims.current_animation_position > 0.3 and actor.anims.current_animation_position < 0.5 and not second_hit_connected:
				
				var space_state = get_parent().get_parent().get_world_2d().direct_space_state
				var query = Physics2DShapeQueryParameters.new()
				query.collision_layer = 2
				query.transform = actor.transform.translated(Vector2(actor.facing * 7, -16))
				query.set_shape(attack_shape)
				var result = space_state.intersect_shape(query, 1)
				if result.size() > 0:
					second_hit_connected = true
					if result[0].collider.sword_hit(actor.position) > 0:
						hit_freeze = HIT_FREEZE_TIME
					else:
						hit_freeze = KILL_FREEZE_TIME
					actor.anims.stop(false)


		"SwordIdle":
			go_to("sword_idle")
			return

	
func handle_input(event: InputEvent):
	pass
	
