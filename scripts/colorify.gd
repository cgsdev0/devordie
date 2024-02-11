extends Area3D

var colors = [Color.WHITE, Color.DARK_TURQUOISE, Color.RED, Color.LIME_GREEN, Color.LIGHT_PINK, Color.YELLOW]

# Called when the node enters the scene tree for the first time.
func _ready():
	match name:
		"ColorRed":
			$CSGCylinder3D.material.albedo_color = Color.RED
		"ColorBlue":
			$CSGCylinder3D.material.albedo_color = Color.DARK_TURQUOISE
		"ColorWhite":
			$CSGCylinder3D.material.albedo_color = Color.WHITE
		"ColorGreen":
			$CSGCylinder3D.material.albedo_color = Color.LIME_GREEN
		"ColorPink":
			$CSGCylinder3D.material.albedo_color = Color.LIGHT_PINK
		"ColorYellow":
			$CSGCylinder3D.material.albedo_color = Color.YELLOW
		"ColorBlack":
			$CSGCylinder3D.material.albedo_color = Color.BLACK
