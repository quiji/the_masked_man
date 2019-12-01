extends CharacterAction

var first_hit: bool = true

func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	Console.count(actor.name+"_hit_state")
	if not first_hit:
		actor.anims.play("2ndHit")
		first_hit = true
	else:
		actor.anims.play("Hit")
		first_hit = false
		
	actor.velocity.x = 0.0

func end(new_state: String) -> void:
	pass
	
	
func run(delta: float) -> void:
	if  actor.anims.current_animation != "Hit" and  actor.anims.current_animation != "2ndHit":
		go_to("sword_idle")
		return
	
	
	if actor.knockback_direction.x < 0.0:
		actor.velocity.x = lerp(actor.velocity.x, -70.0, Smoothstep.stop4(delta))
	else:
		actor.velocity.x = lerp(actor.velocity.x, 70.0, Smoothstep.stop4(delta))
		

	actor.move_and_slide(actor.velocity, Vector2(0.0, -1.0))
	
func handle_input(event: InputEvent):
	pass
	
