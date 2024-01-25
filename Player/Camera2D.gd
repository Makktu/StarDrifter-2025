extends Camera2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func dynamic_zoom(player_velocity_x, player_velocity_y):
	if player_velocity_x > 50 or player_velocity_y > 50:
		if zoom.x > 1:
			zoom.x -= 0.005
			zoom.y -= 0.005
	else:
		if zoom.x < 2:
			zoom.x += 0.001
			zoom.y += 0.001
