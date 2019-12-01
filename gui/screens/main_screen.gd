extends Control


onready var tune = $theme
onready var tween = $tween
onready var start = $menu/vbox/start
onready var quit = $menu/vbox/quit
onready var tutorial = $menu/vbox/tutorial

func _ready():
	tween.connect("tween_completed", self, "_on_tween_completed")
	
	start.connect("pressed", self, "_on_pressed")
	quit.connect("pressed", self, "_on_quit")
	tutorial.connect("pressed", self, "_on_tutorial")
	start.grab_focus()
	

func _on_pressed():
	if tune.playing:
		tween.interpolate_property(tune, "volume_db", 0.0, -80.0, 0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.start()
	else:
		GameState.spawn()

func _on_quit():
	get_tree().quit()

func _on_tutorial():
	pass

func _on_tween_completed(obj, prop):
	GameState.spawn()

