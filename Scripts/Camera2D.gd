extends Camera2D

var zoomout_amount = 0.0035
var zoomin_amount = 0.001
@onready var starting_zoom = zoom.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func dynamic_zoom(player_velocity_x, player_velocity_y, special = null):
	if player_velocity_x > 50 or player_velocity_y > 50 or player_velocity_x < -50 or player_velocity_y < -50:
		if zoom.x > 1:
			zoom.x -= zoomout_amount
			zoom.y -= zoomout_amount
	else:
		if zoom.x < starting_zoom:
			zoom.x += zoomin_amount
			zoom.y += zoomin_amount
