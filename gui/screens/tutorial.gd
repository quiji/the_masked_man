extends Control

enum Tutorials {Run, Jump, Hang, Leap, UpLeap, LongJump, BackJump, Attack}
onready var tutor = $tutor


func _ready():
	hide()
	pass # Replace with function body.

func teach(which: int) -> void:
	show()
	match which:
		Tutorials.Run:
			tutor.play("run")
		Tutorials.Jump:
			tutor.play("jump")
		Tutorials.Hang:
			tutor.play("hang")
		Tutorials.Leap:
			tutor.play("Leap")
		Tutorials.UpLeap:
			tutor.play("UpLeap")
		Tutorials.LongJump:
			tutor.play("LongJump")
		Tutorials.BackJump:
			tutor.play("BackJump")
		Tutorials.Attack:
			tutor.play("Attack")
			
