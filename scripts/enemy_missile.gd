extends CharacterBody2D

@onready var timer = $Timer
@onready var timer_2 = $Timer2
@onready var animation_player = $AnimationPlayer
@onready var cpu_particles_2d = $CPUParticles2D
@onready var player: Node2D = null

var target_position: Vector2
var launched : bool = false
#var speed : int = 40
var speed : float = Global.universal_speed / 90
#var acceleration : float = 1.5
var acceleration : float = Global.universal_speed / 100
var missile_active : bool = false
#var direction_of_movement = Vector2(0, -1).rotated(rotation)
var random_activation_time = Global.random_float_number(4.0, 10.0)
var pusher_active : bool = false

func _process(delta):
	if pusher_active and not launched:
		target_position = player.global_position
		look_at(target_position)
	if launched:			
		position += transform.x * speed * delta 
		speed += acceleration
	if Global.play_mode == 0 and speed > 300:
		queue_free()
	if speed > 600:
		queue_free()
	

func _on_visible_on_screen_notifier_2d_screen_entered():
	player = get_tree().get_first_node_in_group("player")
	timer_2.wait_time = random_activation_time + 1.75
	timer.start()
	timer_2.start()


func _on_visible_on_screen_notifier_2d_screen_exited():
	pusher_active = false
	if launched:
		queue_free()


func _on_timer_timeout():
	pusher_active = true
	animation_player.play("expand")
	

func _on_timer_2_timeout():
	animation_player.play("pre_launch")
	cpu_particles_2d.emitting = true
	launched = true


func _on_area_2d_body_entered(body):
	print("BODY", body.name)


func _on_area_2d_area_entered(area):
	if area.name == "bullet":
		speed = -speed
			
		
