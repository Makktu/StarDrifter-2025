extends Node2D

@onready var global = $/root/Global
@onready var player = $Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_zoom_out_1_body_entered(body):
	print(body.name)
	if body.name != 'Player':
		return
	if global.alarm_triggered:
		return
	global.alarm_triggered = true
	player.camera_special('zoomout')
	global.toggle_bgm('off')
	global.sound_alarm()
	
