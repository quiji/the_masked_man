extends CharacterAction


var wait: float
var swipe_count: int = 0

func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	wait = 0.3
	#actor.anims.play("Wait")
	if states.prev_is("wait"):
		GUI.open_enemy_health_bar(actor.lives)
	pass
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	if wait > 0.0:
		wait -= delta
		return
		
		
	var direction : Vector2 = actor.enemy.position - actor.position
	
	if direction.length() < 70.0 and swipe_count == 0:
		swipe_count += 1
		go_to("swipe")
	else:
		swipe_count = 0
		go_to("pierce_leap")
	
	
	
