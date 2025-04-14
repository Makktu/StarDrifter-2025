extends CharacterBody2D

@onready var timer = $Timer
@onready var timer_2 = $Timer2
@onready var animation_player = $AnimationPlayer
@onready var cpu_particles_2d = $CPUParticles2D

var speed = 20
var acceleration = 1
var direction = -1
var missile_active : bool = false
var direction_of_movement = Vector2(0, direction).rotated(rotation)
var random_activation_time = Global.random_float_number(3.0, 9.0)
var start_pos_y = position.y

func _ready():
	print(start_pos_y)


func _process(delta):
	if missile_active:
		position += direction_of_movement.rotated(PI/2) * speed * delta
		speed += acceleration
		if speed <= 150:
			acceleration += 0.15
	if position.y >= (start_pos_y + 75):
		print(position.y)
		direction_of_movement = Vector2(0, -direction).rotated(rotation)

func _on_visible_on_screen_notifier_2d_screen_entered():
	timer_2.wait_time = random_activation_time - 1.75
	timer.wait_time = random_activation_time
	cpu_particles_2d.emitting = true
	timer.start()
	timer_2.start()


func _on_visible_on_screen_notifier_2d_screen_exited():
	print("Missile gone ")
	queue_free()


func _on_timer_timeout():
	missile_active = true
	animation_player.play("expand")
	cpu_particles_2d.speed_scale = 2.0
	cpu_particles_2d.amount = 500
	

func _on_timer_2_timeout():
	animation_player.play("pre_launch")
