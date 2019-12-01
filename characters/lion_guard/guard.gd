tool
extends Sprite

export (bool) var update setget set_update

func _ready():
	
	$"../anims".connect("animation_finished", self, "_on_anim_finished" )

func set_update(do_we):
	
	if not has_node("../anims"):
		return

	var anim = $"../anims".get_animation("DrawSword")
	anim.loop = false

	anim = $"../anims".get_animation("Attack")
	anim.loop = false

	anim = $"../anims".get_animation("2ndAttack")
	anim.loop = false

	anim = $"../anims".get_animation("Hit")
	anim.loop = false

	anim = $"../anims".get_animation("2ndHit")
	anim.loop = false

	anim = $"../anims".get_animation("SwordDeath")
	anim.loop = false

	anim = $"../anims".get_animation("Attack")
	var track :int = prepare_track(anim)
	anim.track_insert_key(track, 0.3, { "method": "sfx", "args": ["attack"] })

	anim = $"../anims".get_animation("2ndAttack")
	track = prepare_track(anim)
	anim.track_insert_key(track, 0.1, { "method": "sfx", "args": ["2ndattack"] })


func prepare_track(anim: Animation) -> int:
	var track :int = -1

	for i in range(anim.get_track_count()):
		var type = anim.track_get_type(i)
		if type == Animation.TYPE_METHOD:
			track = i

	if track >= 0 :
		anim.remove_track(track)
		
	track = anim.add_track(Animation.TYPE_METHOD)

	anim.track_set_path(track, ".")

	return track

func _on_anim_finished(anim_name: String) -> void:
	match anim_name:
		"DrawSword":
			$"../anims".play("SwordIdle")
			
		"Attack":
			$"../anims".play("2ndAttack")
		"2ndAttack":
			$"../anims".play("SwordIdle")
		"Hit":
			$"../anims".play("SwordIdle")
		"2ndHit":
			$"../anims".play("SwordIdle")
			

