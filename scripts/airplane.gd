extends Node3D


func hide_airplane():
	for child in get_children():
		child.hide()
	$Hearse.show()

func hide_hearse():
	for child in get_children():
		child.show()
	$Hearse.hide()
	
var rng = RandomNumberGenerator.new()
func randomize():
	if rng.randf_range(0.0, 100.0) < 20.0:
		hide_airplane()
	else:
		hide_hearse()
