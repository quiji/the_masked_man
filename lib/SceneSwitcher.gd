extends CanvasLayer

onready var anims = $anims


func change_scene(path: String) -> void:
	anims.play("fade_out")
	yield(anims, "animation_finished")
	get_tree().change_scene(path)
	anims.play("fade_in")
	yield(anims, "animation_finished")

	
