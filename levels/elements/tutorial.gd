extends Area2D

enum Tutorials {Run, Jump, Hang, Leap, UpLeap, LongJump, BackJump, Attack}

export (Tutorials) var which


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_entered")
	connect("body_exited", self, "_on_exited")
	


func _on_entered(boduy):
	GUI.tutorial.teach(which)


func _on_exited(boduy):
	GUI.tutorial.hide()
