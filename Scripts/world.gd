extends Node2D

@onready var global = $/root/Global
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_zoom_out_1_body_entered(body):
	player.camera_special('zoomout')
	global.sound_alarm()
