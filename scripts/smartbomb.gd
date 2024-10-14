extends AnimatedSprite2D

func _ready():
	play("smartbomb")

func _on_area_2d_area_entered(area):
	if area.name == 'Player':
		$"/root/Global".smart_bomb_equipped = true
		queue_free()
