extends Node

var sensitivity = 0.1

var rating = 5
var score = 0

var main_cake

func decrease_rating():
	rating -= 1
	if rating <= 0:
		get_tree().change_scene_to_file("res://game_over.tscn")
	
func increase_rating():
	rating += 1
	score += 1
	if rating > 5:
		rating = 5

var fullscreen = false
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		rating = 5
		score = 0
		get_tree().change_scene_to_file("res://materials/main.tscn")
	if Input.is_action_just_pressed("fullscreen"):
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen = !fullscreen
