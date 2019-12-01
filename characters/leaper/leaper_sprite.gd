tool
extends Sprite

export (bool) var update setget set_update

func _ready():
	
	$"../anims".connect("animation_finished", self, "_on_anim_finished" )

func set_update(do_we):
	
	if not Engine.editor_hint:
		return
	
	
	var track: int
	var anim = $"../anims".get_animation("RunToIdle")
	anim.loop = false

	anim = $"../anims".get_animation("RunStop")
	anim.loop = false

	anim = $"../anims".get_animation("RunTurn")
	anim.loop = false

	anim = $"../anims".get_animation("RunStopTurn")
	anim.loop = false

	anim = $"../anims".get_animation("JumpPeak")
	anim.loop = false

	anim = $"../anims".get_animation("Land")
	anim.loop = false

	anim = $"../anims".get_animation("LandToRun")
	anim.loop = false

	anim = $"../anims".get_animation("StartLeap")
	anim.loop = false

	anim = $"../anims".get_animation("LandLeap")
	anim.loop = false
	
	anim = $"../anims".get_animation("Leap")
	anim.loop = false

	anim = $"../anims".get_animation("LeapCombo")
	anim.loop = false

	anim = $"../anims".get_animation("StartUpLeap")
	anim.loop = false
	
	anim = $"../anims".get_animation("UpLeap")
	anim.loop = false

	anim = $"../anims".get_animation("UpLeapCombo")
	anim.loop = false


	anim = $"../anims".get_animation("LongJump")
	anim.loop = false

	anim = $"../anims".get_animation("Roll")
	anim.loop = false

	anim = $"../anims".get_animation("WallStomp")
	anim.loop = false

	anim = $"../anims".get_animation("LedgeHang")
	anim.loop = false

	anim = $"../anims".get_animation("UpLeapToFall")
	anim.loop = false

	anim = $"../anims".get_animation("BackJump")
	anim.loop = false
	
	anim = $"../anims".get_animation("DrawSword")
	anim.loop = false

	anim = $"../anims".get_animation("Attack")
	anim.loop = false

	anim = $"../anims".get_animation("2ndAttack")
	anim.loop = false

	anim = $"../anims".get_animation("SwordHit")
	anim.loop = false

	anim = $"../anims".get_animation("SwordDeath")
	anim.loop = false

	if do_we:
		anim = $"../anims".get_animation("Run")
		track = prepare_track(anim)
		
		anim.track_insert_key(track, 0.2, { "method": "sfx", "args": ["steps"] })
		anim.track_insert_key(track, 0.8, { "method": "sfx", "args": ["steps"] })

		anim = $"../anims".get_animation("Land")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["land"] })
		
		anim = $"../anims".get_animation("LandLeap")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["land"] })
		
		anim = $"../anims".get_animation("LandToRun")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["land"] })
		
		anim = $"../anims".get_animation("Roll")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["land"] })

		anim = $"../anims".get_animation("Leap")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["leapsteps"] })

		anim = $"../anims".get_animation("LeapCombo")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["leapsteps"] })

		anim = $"../anims".get_animation("UpLeap")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["leapsteps"] })

		anim = $"../anims".get_animation("UpLeapCombo")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["leapsteps"] })

		anim = $"../anims".get_animation("UpLeapToFall")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["leapsteps"] })

		anim = $"../anims".get_animation("WallStomp")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["wallstomp"] })

		anim = $"../anims".get_animation("RunStop")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["slide"] })

		anim = $"../anims".get_animation("RunStopTurn")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["slide"] })

		anim = $"../anims".get_animation("Attack")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["attack"] })

		anim = $"../anims".get_animation("2ndAttack")
		track = prepare_track(anim)
		anim.track_insert_key(track, 0.0, { "method": "sfx", "args": ["2ndattack"] })


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
		"RunStop":
			$"../anims".play("RunToIdle")
		"RunToIdle":
			$"../anims".play("Idle")
		"RunStopTurn":
			$"../anims".play("RunTurn")
		"RunTurn":
			$"../anims".play("Run")
		"JumpPeak":
			$"../anims".play("Fall")
		"Land":
			$"../anims".play("Idle")
		"LandToRun":
			$"../anims".play("Run")
		"StartLeap":
			$"../anims".play("Leap")
		"Leap", "LeapCombo":
			$"../anims".play("LandLeap")
		"StartUpLeap":
			$"../anims".play("UpLeap")
		"UpLeap", "UpLeapCombo":
			$"../anims".play("Fall")
		"UpLeapToFall":
			$"../anims".play("JumpPeak")
		"BackJump":
			$"../anims".play("JumpPeak")
		"LandLeap":
			$"../anims".play("Idle")
		"Roll":
			$"../anims".play("Idle")
		"LongJump":
			$"../anims".play("Fall")
		"WallStomp":
			$"../anims".play("Fall")
		"SwordHit":
			$"../anims".play("Idle")
		#"DrawSword":
		#	$"../anims".play("IdleSword")

