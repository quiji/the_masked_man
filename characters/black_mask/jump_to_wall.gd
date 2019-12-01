extends CharacterAction

var start_position: Vector2
var end_position: Vector2
var t: float = 0.0
var duration: float = 0.0

func install() -> void:
	pass

func start(sub_state: String) -> void:
	
	var closest_one: Vector2
	var last_distance: float = 1000.0 * 1000.0
	for i in range(actor.wall_jump_points.size()):
		var pos: Vector2 = actor.wall_jump_points[i] - actor.position
		var len_squ: float = pos.length_squared()
		if len_squ < last_distance:
			last_distance = len_squ
			closest_one = actor.wall_jump_points[i]
		
	start_position = actor.position
	end_position = closest_one
	t = 0.0
	duration = 0.6
	
	
func end(new_state: String) -> void:
	pass
	
	
func run(delta: float) -> void:
	
	if t <= 1.0:
		actor.position.x = lerp(start_position.x, end_position.x, t)
		actor.position.y = lerp(start_position.y, end_position.y, Smoothstep.stop3(t))
		
		
		t += delta / duration
	else:
		
		go_to("wall_jump")
