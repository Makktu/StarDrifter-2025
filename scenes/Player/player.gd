extends CharacterBody2D

@onready var acceleration = 60 #30
@onready var max_speed = 100
@onready var gravity = 0 #0 FOR FULL WEIGHTLESSNESS
@onready var rotation_speed = 5 #6
@onready var starting_energy = 100
@onready var global = $/root/Global
@onready var colliding_effect = $collision_particles

signal energy_change

# =============== SHOOTING
const bullet = preload("res://scenes/Player/bullet/bullet.tscn")
var player_is_shooting := false # toggle to prevent continuous fire
var firing_points := 1 # start only able to shoot from tip of craft
var smart_bomb_equipped = true
# ========================

var input_vector : Vector2
var rotation_direction: int

var energy_warning_shown = false

var player_is_thrusting = false
var thrusting_for = 0

var collided_with = ""

func _physics_process(delta):
	
	if Input.is_action_pressed("Left") and rotation_direction != -1:
		rotation_direction -= 1
	if Input.is_action_pressed("Right") and rotation_direction != 1:
		rotation_direction += 1
	if Input.is_action_just_released("Left") or Input.is_action_just_released("Right"):
		rotation_direction = 0
		
	if Input.is_action_pressed("shoot") and !player_is_shooting:
		player_is_shooting = true
		shoot_bullets()
		
	if Input.is_action_just_released("shoot"):
		player_is_shooting = false
	
	# smartbomb deployment
	if Input.is_action_just_pressed("Up") and smart_bomb_equipped:
		global.smart_bomb_active = true
		smart_bomb_equipped = false
		$SmartbombTimer.start()
		 
		
	velocity += Vector2(input_vector.x * acceleration * delta, 0).rotated(rotation)
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	
	$Camera2D.dynamic_zoom(velocity.x, velocity.y)
	
	rotation += rotation_direction * rotation_speed * delta	
		
	# =================================#
	# collision check with environment # 
	# =================================#	
	var collided := move_and_collide(velocity * delta)
	if collided and not get_floor_normal():
		handle_collision(collided)
		
	# =================================#

	input_vector.x = Input.get_action_strength("Thrust")
	
	if Input.is_action_pressed("Thrust"):
		starting_energy -= 0.02
		emit_signal("energy_change", starting_energy)
		$Thrust_Manager.thrust_pressed()
		if !player_is_thrusting:
			player_is_thrusting = true
			$hud.thrust_pressed()
		
	if Input.is_action_just_released("Thrust"):
		$Thrust_Manager.thrust_released()
		$hud.thrust_released()
		player_is_thrusting = false
		
	
	$hud.show_velocity(velocity.x, velocity.y, delta)
		
	if starting_energy < 9500 and !energy_warning_shown:
		energy_warning_shown = true
		$hud.show_warning()
		
		
func handle_collision(collided):
	show_collision_particles()
	velocity = velocity.bounce(collided.get_normal())
	var collision_rotation_penalty: int = 1
	if rotation_direction == 1:
		rotation_direction = -collision_rotation_penalty
	elif rotation_direction == -1:
		rotation_direction = collision_rotation_penalty
	else:
		rotation_direction = collision_rotation_penalty

	
func show_collision_particles():
	colliding_effect.emitting = true
	$Camera2D.shake_camera(2, 6.1, 'collision')
			
func camera_special(type):
	if !type:
		return
	$Camera2D.zoom_special(type)
	
	
func shoot_bullets():
	var times_fired = 0
	for n in $firing_points.get_children():
		if times_fired == 0 and firing_points == 2: # skip firing from tip if firing points is 2
			times_fired += 1
			continue
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = n.global_position
		bullet_instance.rotation_degrees = n.global_rotation_degrees - 90
		get_parent().add_child(bullet_instance)
		times_fired += 1
		if (times_fired == firing_points) and firing_points == 1:
			break



func _on_smartbomb_timer_timeout():
	global.smart_bomb_active = false
