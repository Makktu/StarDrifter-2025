extends CharacterBody2D

@onready var timer = $Timer
@onready var timer_2 = $Timer2
@onready var animation_player = $AnimationPlayer
@onready var cpu_particles_2d = $CPUParticles2D
@onready var player: Node2D = null

var target_position: Vector2
var launched : bool = false
var speed : int = 40
var acceleration : float = 1.5
var missile_active : bool = false
var direction_of_movement = Vector2(0, -1).rotated(rotation)
var random_activation_time = Global.random_float_number(3.0, 9.0)

func _process(delta):
	if launched:
		position += transform.x * speed * delta 
		speed += acceleration
	if speed > 200:
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered():
	player = get_tree().get_first_node_in_group("player")
	timer_2.wait_time = random_activation_time - 1.75
	timer.wait_time = random_activation_time
	cpu_particles_2d.emitting = true
	timer.start()
	timer_2.start()


func _on_visible_on_screen_notifier_2d_screen_exited():
	if launched:
		print("Missile gone ")
		queue_free()


func _on_timer_timeout():
	if player:
		target_position = player.global_position
		look_at(target_position)
	animation_player.play("expand")
	cpu_particles_2d.speed_scale = 2.0
	cpu_particles_2d.amount = 500
	

func _on_timer_2_timeout():
	animation_player.play("pre_launch")
	launched = true
