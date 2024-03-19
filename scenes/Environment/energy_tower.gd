extends Sprite2D

var rotation_speed = 0.4
var scale_min = 0.8
var scale_max = 1.2
var scale_scale = 0.0005

func _ready():
	$AnimationPlayer.play('glow')

func _process(delta):
	rotation_degrees += rotation_speed
	scale.x += scale_scale
	scale.y += scale_scale
	if scale.x > scale_max or scale.x < scale_min:
		scale_scale = -scale_scale


func _on_area_2d_area_entered(area):
	pass # Replace with function body.
