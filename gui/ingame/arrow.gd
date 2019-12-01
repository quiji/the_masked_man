tool
extends Sprite

export (bool) var update setget set_update

func _ready():
	
	$"../anims".connect("animation_finished", self, "_on_anim_finished" )

func set_update(do_we):
	
	var anim = $"../anims".get_animation("Appear")
	anim.loop = false

	anim = $"../anims".get_animation("Disappear")
	anim.loop = false


func _on_anim_finished(anim_name: String) -> void:
	match anim_name:
		"Appear":
			$"../anims".play("Point")
		"Disappear":
			hide()
			
		
