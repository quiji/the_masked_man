extends Area2D

export (String, FILE) var target_scene
export (String) var target_door

var spawn_position: Vector2
var spawn_position_node: Position2D

func _ready():
	connect("body_entered", self, "_on_body_entered")

	for i in range(get_child_count()):
		var child = get_child(i)
		if child is Position2D:
			spawn_position = position + child.position
			spawn_position_node = child

func _on_body_entered(fella):
	GameState.enter(target_scene, target_door)

func get_facing() -> float:
	
	if not spawn_position_node:
		return 1.0
	
	var direction : Vector2 = spawn_position_node.position.normalized()

	if direction.dot(Vector2(1.0, 0.0)) >= 0.0:
		return 1.0
	else:
		return  -1.0
	
