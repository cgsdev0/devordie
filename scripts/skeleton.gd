@tool
extends Node3D

@export var animati: String = "humans/idle"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play(animati)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
