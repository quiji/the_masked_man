extends Area2D

signal switched

onready var anims = $anims
onready var arrow_pos = $arrow_pos

export (bool) var open_block_doors = true

var can_activate: bool = false


func _ready():
	
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
	can_activate = false

func _on_body_entered(fella):

	GUI.prompt_arrow(arrow_pos)
	can_activate = true

func _on_body_exited(fella):
	
	GUI.unprompt_arrow()
	can_activate = false
	

func _unhandled_input(event):
	
	if event.is_action_pressed("ui_down") and can_activate:
		anims.play("PullSwitch")
		if open_block_doors:
			get_tree().call_group("block_doors", "switch_if_owner", name)
		emit_signal("switched")
