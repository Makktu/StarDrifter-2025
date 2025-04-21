extends CharacterBody2D

func _ready():
	pass
	
func _physics_process(delta):
	rotation += 0.01
	position.x += 0.05
	position.y -= 0.05
