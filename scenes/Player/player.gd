extends CharacterBody2D

signal energy_change

@onready var acceleration = 60 #30
@onready var max_speed = 100
@onready var gravity = 0 #0 FOR FULL WEIGHTLESSNESS
@onready var rotation_speed = 5 #6
@onready var global = $/root/Global
@onready var colliding_effect = $collision_particles
# =============== SHOOTING
const bullet = preload("res://scenes/Player/bullet/bullet.tscn")
var player_is_shooting := false # toggle to prevent continuous fire
@onready var firing_points = global.player_bullets_can_be_fired # start only able to shoot from tip of craft
# ========================
@onready var starting_energy = global.player_energy
@onready var energy_replenish_amount = global.player_energy_replenish_amount
var input_vector : Vector2
var rotation_direction: int
var energy_warning_shown = false
var player_is_thrusting = false
var thrusting_for = 0
var collided_with = ""

func _physics_process(delta):
	
	if global.player_damage:
		global.player_damage = false
		inflict_damage()
	
	if starting_energy <= 0 && global.dev_damage_on:
		# bring up pause menu with condition true (Game Over)
		$hud._on_pause_button_pressed(true)
		
	if starting_energy <= 50:
		global.smart_bomb_equipped = false
		$hud.smartbomb_message_toggle(false)
	
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
	if Input.is_action_just_pressed("Up") and global.smart_bomb_equipped and starting_energy >= 51:
		global.smart_bomb_active = true
		starting_energy -= 50
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
		handle_collision(collided, velocity.x, velocity.y)
		
	# =================================#

	input_vector.x = Input.get_action_strength("Thrust")
	
	if Input.is_action_pressed("Thrust"):
		starting_energy -= 0.02
		$Thrust_Manager.thrust_pressed()
		if !player_is_thrusting:
			player_is_thrusting = true
			$hud.thrust_pressed()
		
	if Input.is_action_just_released("Thrust"):
		$Thrust_Manager.thrust_released()
		$hud.thrust_released()
		player_is_thrusting = false
		
	
	$hud.show_velocity(velocity.x, velocity.y, delta)
		
	#if starting_energy < 9500 and !energy_warning_shown:
		#energy_warning_shown = true
		#$hud.show_warning()
		
	if firing_points != global.player_bullets_can_be_fired:
		firing_points = global.player_bullets_can_be_fired
	
	# background energy replenishment as a matter of course	
	energy_replenish()
	
	
func energy_replenish():
	if starting_energy < 0:
		starting_energy = 0
	if starting_energy < global.player_energy:
		starting_energy += energy_replenish_amount
	emit_signal("energy_change", starting_energy)
	if starting_energy >= 51:
		$hud.smartbomb_message_toggle(true)
		
		
func handle_collision(collided, speed_x, speed_y):
	# collision penalty for all collisions
	# not just the 'World' environment
	var collision_strength = 'collision_soft'
	if speed_x >= 50 or speed_y >= 50:
		collision_strength = 'collision_hard'		
	starting_energy -= global.taking_damage['World1'][collision_strength]
		
	emit_signal("energy_change", starting_energy)
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
	var firing_sparkle = $collision_particles
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
	global.smart_bomb_equipped = true # will be made false in _physics_process if energy < 51


func _on_player_enemy_collision_area_entered(area):
	print(area.name)
	

func inflict_damage():
	starting_energy -= global.player_amount_damaged
	emit_signal("energy_change", starting_energy)
