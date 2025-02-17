extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var line = Line2D.new()
	add_child(line)
	line.default_color = Color.WHITE
	line.width = 2.0
	line.points = [Vector2(100, 100), Vector2(200, 200)]  # Starting and ending points


#func _process(delta):
	#pass
