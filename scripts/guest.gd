extends Node3D


var timer = 0.0
var delay = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	%Bubble.hide()
	delay = randf_range(1.0, 10.0)
	$Area3D.name = "Table" + name
	%Cake.randomize()
	
func _process(delta):
	delay -= delta
	if delay < 0.0 && ! %Bubble.visible && !moving_on:
		if randi_range(0, 10) == 4:
			$Skele/Rare.play()
		%Bubble.show()
	if !%Bubble.visible || moving_on:
		return
	timer += delta
	if timer > 30.0:
		descend()

var Cake = preload("res://cake.tscn")

var moving_on = false
func cake_match(a, b):
	return true
	
func descend():
	moving_on = true
	$Skele/Fail.play()
	%Bubble.hide()
	GameState.decrease_rating()
	$AnimationPlayer.play("descend")
	await $AnimationPlayer.animation_finished
	moving_on = false
	timer = 0.0
	%Cake.randomize()
	delay = randf_range(1.0, 30.0)
	
func give_cake(cake):
	if ! %Bubble.visible:
		return
	if cake.is_blank():
		return
	if moving_on:
		return
		
	%Bubble.hide()
	var old_owner = cake.owner
	cake.unique_name_in_owner = false
	cake.owner = self.owner
	cake.name = "trash"
	var old_parent = cake.get_parent()
	var old_transform = cake.global_transform
	cake.get_parent().remove_child(cake)
	%CakeMount.add_child(cake)
	cake.global_position = %CakeMount.global_position
	var new_cake = Cake.instantiate()
	new_cake.reset()
	new_cake.name = "MainCake"
	old_parent.add_child(new_cake)
	new_cake.owner = old_owner
	new_cake.global_transform = old_transform
	
	moving_on = true
	if cake.matches(%Cake):
		await get_tree().create_timer(1.0).timeout
		GameState.increase_rating()
		cake.disappear()
		$AnimationPlayer.play("ascend")
		await $AnimationPlayer.animation_finished
		moving_on = false
		timer = 0.0
		delay = randf_range(1.0, 20.0)
	else:
		$Skele/Fail.play()
		await get_tree().create_timer(1.0).timeout
		GameState.decrease_rating()
		cake.disappear()
		$AnimationPlayer.play("descend")
		await $AnimationPlayer.animation_finished
		moving_on = false
		timer = 0.0
		delay = randf_range(1.0, 20.0)
	
	%Cake.randomize()
