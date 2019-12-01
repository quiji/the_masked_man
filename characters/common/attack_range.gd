extends Area2D


var attacked_fella = null
var current_position: Vector2

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	current_position = position

func enable(_offset:Vector2 = Vector2()) -> void:
	position = _offset + current_position
	monitoring = true

func disable() -> void:
	monitoring = false

func _on_body_entered(poor_fella):
	attacked_fella = poor_fella

func _on_body_exited(poor_fella):
	attacked_fella = null

func get_attacked_fella():
	return attacked_fella
	
	
