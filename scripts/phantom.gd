extends CharacterBody2D

var laser_beam = preload("res://scenes/phantom_laser.tscn")
var time_to_next_phase_in = 4.0 # time in seconds to next appearance on map
@onready var phase_timer = $PhaseTimer
@onready var fire_timer = $FireTimer
@onready var laser_spawn = $LaserSpawn
@onready var sprite = $Sprite2D
@onready var the_player = get_tree().get_nodes_in_group("player")[0]
@onready var collision_shape = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var blow_up_anim = $AnimatedSprite2D
@onready var collision_particles = $collision_particles
@onready var bullet_area = $bullet_area
@onready var second_collision_shape = $bullet_area/CollisionShape2D

#var enemy_speed = 10
var enemy_speed = Global.universal_speed / 40
#var rotation_speed = 2.0  # smoother tracking
var rotation_speed : float = Global.universal_speed / 200
var phantom_active = false
var phantom_energy = 4


func _physics_process(delta):
	if phantom_active: # if phantom is not on-screen or faded out, phantom is inert	
		var direction = global_position.direction_to(the_player.global_position)
		var target_angle = direction.angle()
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
		velocity = direction * enemy_speed * delta	
		var collided := move_and_collide(velocity * delta)
		if phantom_energy <= 0:
			fire_timer.stop()
			phantom_active = false
			fade_out()
						
	
func fade_out():
	# create Tween object
	var tween = get_tree().create_tween()
	# Tween the alpha value back to 0
	tween.tween_property(
		sprite, 
		"modulate:a", 
		0.0,  # Target alpha
		2.0   # Duration in seconds
		).set_ease(Tween.EASE_IN_OUT)
	phantom_active = false
	collision_shape.disabled = true
	second_collision_shape.disabled = true
	bullet_area.monitoring = false
	bullet_area.monitorable = false
	phase_timer.start()
	
	
func fade_in():
	# create Tween object
	var tween = get_tree().create_tween()
	# Tween the alpha value back to 0
	tween.tween_property(
		sprite, 
		"modulate:a", 
		1.0,  # Target alpha
		2.0   # Duration in seconds
		).set_ease(Tween.EASE_IN_OUT)
	phantom_active = true
	collision_shape.disabled = false
	second_collision_shape.disabled = false
	bullet_area.monitoring = true
	bullet_area.monitorable = true
	fire_timer.start()


func _on_visible_on_screen_enabler_2d_screen_entered():
	phantom_active = true
	fire_timer.start()


func _on_visible_on_screen_enabler_2d_screen_exited():
	phantom_active = false	
	fire_timer.stop()


func _on_fire_timer_timeout():
	var new_laser = laser_beam.instantiate()
	add_child(new_laser)
	fire_timer.start()
	

func _on_bullet_area_area_entered(area):
	if area.name == 'bullet':
		phantom_energy -= 2
		animation_player.play("phantom_hit")
	else:
		phantom_energy -= 1


func _on_phase_timer_timeout():
	phantom_energy = 4
	phantom_active = true
	fade_in()
