extends Camera2D

var zoomout_amount = 0.0040
var zoomin_amount = 0.0020
@onready var starting_zoom = zoom.x

var randomShakeStrength: float = 1.0
var shakeFade: float = 0.02
var shakeRng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

var thrust_shaking := false


func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * (delta / 2))
		offset = randomShakeOffset()

func dynamic_zoom(zoom_direction):
	if zoom_direction == "in":
		for n in 2000:
			zoom.x += zoomin_amount * 0.2
			zoom.y += zoomin_amount * 0.2
	else:
		for n in 2000:
			zoom.x -= zoomin_amount * 0.2
			zoom.y -= zoomin_amount * 0.2
			
func thrust_shake():
	if thrust_shaking:
		return
	shake_strength = randomShakeStrength

func randomShakeOffset() -> Vector2:
	return Vector2(shakeRng.randf_range(-shake_strength, shake_strength), shakeRng.randf_range(-shake_strength, shake_strength))
	

func shake_camera(duration: float, strength: float, special_shake: String = '') -> void:
	if !$"/root/Global".dev_screenshake_on:
		return
	var shake_start_time: float = Time.get_ticks_msec() / 1000.0 # convert to seconds
	while (Time.get_ticks_msec() / 1000.0) - shake_start_time < duration:
		if !thrust_shaking and not special_shake:
			break
		var x: float = randf_range(-strength, strength)
		var y: float = randf_range(-strength, strength)
		global_position = Vector2(x, y) + $"..".global_position
		await get_tree().process_frame
	
	global_position = $"..".global_position		
