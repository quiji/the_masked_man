extends Node2D

export (bool) var enable_anims_offscreen = false

signal animation_finished(which)

var current_anim = "Idle"
var playing
var playing_is_backwards = false

func _ready():
	playing = current_anim
	if $anim_player.has_animation(current_anim):
		$anim_player.play(playing)
	$anim_player.connect("animation_finished", self, "_on_anim_player_animation_finished")

	$sprite.light_mask = get_parent().light_mask

	var visibility_enabler = VisibilityEnabler2D.new()
	visibility_enabler.rect = Rect2(-100, -100, 200, 200)
	visibility_enabler.pause_animations = not enable_anims_offscreen
	add_child(visibility_enabler)


func play(new_anim, is_backwards = false):
	var about_to_play = new_anim


	if about_to_play != playing or playing_is_backwards != is_backwards:


		var current_pos = null
		if new_anim == current_anim and playing_is_backwards == is_backwards:
			current_pos = $anim_player.current_animation_position

		current_anim = new_anim
		playing = about_to_play
		playing_is_backwards = is_backwards
		if is_backwards:
			$anim_player.play_backwards(playing)
		else:
			$anim_player.play(playing)

		if current_pos != null:
			$anim_player.seek(current_pos, true)

func get_current_anim():
	return current_anim

func switch_current_anim(vel):
	if vel < 0:
		$sprite.flip_h = true
	elif vel > 0:
		$sprite.flip_h = false

func face_right(do_it: bool):
	$sprite.flip_h = not do_it

func is_facing_right():
	return not $sprite.flip_h

func is_finished():
	return not $anim_player.is_playing()


func _on_anim_player_animation_finished(animation : String) -> void:
	emit_signal("animation_finished", animation)

func react(to_what):

	emit_signal(to_what)


