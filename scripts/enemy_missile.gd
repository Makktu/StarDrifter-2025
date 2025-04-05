extends CharacterBody2D

@onready var timer = $Timer

var speed = 20
var acceleration = 1
var missile_active : bool = false
var left_boundary = position.x - 200
var right_boundary = position.x + 1000
var plus_minus = -1
var direction_of_movement = Vector2(0, plus_minus).rotated(rotation)


func _process(delta):
	if missile_active:
		position += direction_of_movement.rotated(PI/2) * speed * delta
		speed += acceleration
		if speed <= 45:
			acceleration += 0.05
		if position.x > right_boundary:
			plus_minus = -1
			direction_of_movement = Vector2(0, plus_minus).rotated(rotation)
		if position.x < left_boundary:
			plus_minus = 1
			direction_of_movement = Vector2(0, plus_minus).rotated(rotation)


func _on_visible_on_screen_notifier_2d_screen_entered():
	timer.start()


func _on_timer_timeout():
	missile_active = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	pass
	#print("Missile ")
	#queue_free()
