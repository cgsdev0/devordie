extends Node3D

enum CakeType {
	TIERED,
	SHEET,
	BLANK
}

@export var layers = 1
@export var cake_type: CakeType = CakeType.TIERED
@export var base_color: Color = Color.WHITE
@export var has_base = true
@export var frosting_color: Color = Color.BLUE
@export var has_frosting = true
@export var frostingMat: BaseMaterial3D
@export var baseMat: BaseMaterial3D

func update_layers():
	%Layer1.hide()
	%Layer2.hide()
	%Layer3.hide()
	if layers > 0:
		%Layer1.show()
	if layers > 1:
		%Layer2.show()
	if layers > 2:
		%Layer3.show()

var rng = RandomNumberGenerator.new()

var cake_types = [CakeType.TIERED, CakeType.SHEET]
var colors = [Color.WHITE, Color.DARK_TURQUOISE, Color.LIME_GREEN, Color.LIGHT_PINK, Color.YELLOW, Color.BLACK]
var unfrosted_base_color = Color.SADDLE_BROWN # Color("#35281E")

func randomize():
	cake_types.shuffle()
	cake_type = cake_types[0]
	if cake_type == CakeType.TIERED:
		layers = rng.randi_range(1, 3)
	if rng.randi_range(1, 8) == 2:
		has_base = false
	colors.shuffle()
	frosting_color = colors[0]
	if has_base:
		colors.shuffle()
		base_color = colors[0]
		while base_color == frosting_color:
			colors.shuffle()
			base_color = colors[0]
	update()
	
func _ready():
	if name == "MainCake":
		GameState.main_cake = self
	update()

func reset():
	cake_type = CakeType.BLANK

func matches(b):
	if b.has_base != has_base:
		return false
	if b.has_frosting != has_frosting:
		return false
	if b.base_color != base_color:
		return false
	if b.frosting_color != frosting_color:
		return false
	if b.cake_type != cake_type:
		return false
	if b.layers != layers:
		return false
	
	return true
	
func disappear():
	if get_tree() == null:
		return
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector3.ZERO, 0.5)
	tween.tween_callback(self.queue_free)
	
func is_blank():
	if cake_type == CakeType.BLANK:
		return true
	return false
var who
func do_thing(thing: String, click, who=null):
	if thing.begins_with("Table"):
		who.get_parent().give_cake(self)
	match thing:
		"BaseCake1":
			cake_type = CakeType.TIERED
			layers = 1
			has_frosting = false
			has_base = false
		"BaseCake2":
			if cake_type == CakeType.TIERED && layers >= 1:
				layers = 2
				has_frosting = false
				has_base = false
		"BaseCake3":
			if cake_type == CakeType.TIERED && layers >= 2:
				layers = 3
				has_frosting = false
				has_base = false
		"BaseCake4":
			cake_type = CakeType.SHEET
			layers = 1
			has_frosting = false
			has_base = false
		"ColorRed":
			if click == "left" && cake_type != CakeType.BLANK:
				has_base = true
				base_color = Color.RED
			elif cake_type != CakeType.BLANK && click == "right":
				frosting_color = Color.RED
				has_frosting = true
		"ColorBlue":
			if click == "left" && cake_type != CakeType.BLANK:
				has_base = true
				base_color = Color.DARK_TURQUOISE
			elif cake_type != CakeType.BLANK && click == "right":
				frosting_color = Color.DARK_TURQUOISE
				has_frosting = true
		"ColorWhite":
			if click == "left" && cake_type != CakeType.BLANK:
				has_base = true
				base_color = Color.WHITE
			elif cake_type != CakeType.BLANK && click == "right":
				frosting_color = Color.WHITE
				has_frosting = true
		"ColorGreen":
			if click == "left" && cake_type != CakeType.BLANK:
				has_base = true
				base_color = Color.LIME_GREEN
			elif cake_type != CakeType.BLANK && click == "right":
				frosting_color = Color.LIME_GREEN
				has_frosting = true
		"ColorPink":
			if click == "left" && cake_type != CakeType.BLANK:
				has_base = true
				base_color = Color.LIGHT_PINK
			elif cake_type != CakeType.BLANK && click == "right":
				frosting_color = Color.LIGHT_PINK
				has_frosting = true
		"ColorYellow":
			if click == "left" && cake_type != CakeType.BLANK:
				has_base = true
				base_color = Color.YELLOW
			elif cake_type != CakeType.BLANK && click == "right":
				frosting_color = Color.YELLOW
				has_frosting = true
		"ColorBlack":
			if click == "left" && cake_type != CakeType.BLANK:
				has_base = true
				base_color = Color.BLACK
			elif cake_type != CakeType.BLANK && click == "right":
				frosting_color = Color.BLACK
				has_frosting = true
	update()
	
func update():
	if !has_base:
		baseMat.albedo_color = unfrosted_base_color
	else:
		baseMat.albedo_color = base_color
	if has_frosting:
		%Layer1/Frosting.show()
		%Layer2/Frosting.show()
		%Layer3/Frosting.show()
		$Sheet/Node3D/Layer1/Frosting.show()
	else:
		%Layer1/Frosting.hide()
		%Layer2/Frosting.hide()
		%Layer3/Frosting.hide()
		$Sheet/Node3D/Layer1/Frosting.hide()
	if cake_type == CakeType.BLANK:
		$Sheet.hide()
		$Tiered.hide()
		layers = 0
		has_frosting = false
		has_base = false
	elif cake_type == CakeType.TIERED:
		$Sheet.hide()
		$Tiered.show()
		update_layers()
	else:
		$Tiered.hide()
		$Sheet.show()
	frostingMat.albedo_color = frosting_color
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
