tool
extends Node2D
var Smoothstep = preload("../Smoothstep.gd")



func _ready():
	
	

	$interpolator.set_method(self, "inter")
	$interpolator2.set_method(self, "inter2")
	$interpolator3.set_method(self, "inter3")
	$interpolator4.set_method(self, "inter4")
	$interpolator5.set_method(self, "inter5")



func inter(t):
	return Smoothstep.arch(t, 4.0)


func inter2(t):
	return Smoothstep.normalized_bezier7(0.3, 0.96, 1.7, 1.4, 1.2, 0.8, t)


func inter3(t):
	return Smoothstep.bezier7( 0.2, 0.5, 0.2, -0.28, -0.5, -0.1, 0.05, 0.0, t)

func inter4(t):
	return Smoothstep.start3(t)

func inter5(t):
	return Smoothstep.bezier7(0.5, 0.8, 0.4, 0.0, 0.4, 0.8, 1.0, 1.0, t)


