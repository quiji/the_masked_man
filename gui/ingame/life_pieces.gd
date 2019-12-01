extends Control

signal full_piece

onready var piece1 = $pieces/piece1
onready var piece2 = $pieces/piece2
onready var piece3 = $pieces/piece3
onready var anims = $anims




var current_pieces :int = 0
func _ready():
	current_pieces = 0
	set_physics_process(false)
	anims.connect("animation_finished", self, "_on_animation_finished")

func set_pieces(number_pieces: int) -> void:
	current_pieces = number_pieces
	update_pieces()


func increment_life_pieces() -> void:
	current_pieces += 1
	update_pieces()
	
func update_pieces() -> void:
	match current_pieces:
		0:
			piece1.show()
			piece2.show()
			piece3.show()
		1: 
			piece1.hide()
			piece2.show()
			piece3.show()
			anims.play("glow")
			#shake(2.0, 4.0, 0.0, _shake.ShakeDirectionTypes.ALL_DIRECTIONS, _shake.ShakeMovementTypes.ARCH)
		2:
			piece1.hide()
			piece2.hide()
			piece3.show()
			anims.play("glow")
			#shake(2.0, 4.0, 0.0, _shake.ShakeDirectionTypes.ALL_DIRECTIONS, _shake.ShakeMovementTypes.ARCH)
		3: 
			piece1.hide()
			piece2.hide()
			piece3.hide()
			anims.play("glow")
			#shake(2.0, 4.0, 0.0, _shake.ShakeDirectionTypes.ALL_DIRECTIONS, _shake.ShakeMovementTypes.ARCH)




func _on_animation_finished(anim_name: String) ->  void:
	if current_pieces == 3:
		current_pieces = 0
		piece1.show()
		piece2.show()
		piece3.show()
		emit_signal("full_piece")


