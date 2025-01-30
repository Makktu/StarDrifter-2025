extends CharacterBody2D

@onready var acceleration = 40 #was 80
@onready var max_speed = 100 # was 200
@onready var gravity = 0 #0 FOR FULL WEIGHTLESSNESS
@onready var rotation_speed = 5 #6
@onready var global = $/root/Global
@onready var colliding_effect = $collision_particles
@onready var pickup_timer = $pickup_timer
@onready var shield_collision_shape = $shield_collision_shape
@onready var shield_gfx = $shield_gfx
@onready var animation_player = $AnimationPlayer
@onready var camera_2d = $Camera2D

# =============== SHOOTING
const bullet = preload("res://scenes/bullet.tscn")
var player_is_shooting := false # toggle to prevent continuous fire
@onready var firing_points = 1 # start only able to shoot from tip of craft
# ========================
@onready var energy_replenish_amount = global.player_energy_replenish_amount
var input_vector : Vector2
var rotation_direction: int
var energy_warning_shown = false
var player_is_thrusting = false
var thrusting_for = 0
var collided_with : String = ""
var pickup_type : String = ""

func _physics_process(delta):
	# if energy depleted bring up pause menu
	if global.player_energy <= 0 && global.dev_damage_on:
		$hud._on_pause_button_pressed(true) # if passing true, means Game Over
	
	if global.player_energy <= 20 and !energy_warning_shown:
		$hud.show_warning(2)
		
	if energy_warning_shown and global.player_energy > 20:
		$hud.show_warning(0)
	
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
		
	velocity += Vector2(input_vector.x * acceleration * delta, 0).rotated(rotation)
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
		
	rotation += rotation_direction * rotation_speed * delta	
		
	# =================================#
	# collision check with environment # 
	# =================================#	
	var collided := move_and_collide(velocity * delta)
	if collided and not get_floor_normal():
		# get the name of the thing collided with
		var this_collided_with = collided.get_collider()
		this_collided_with = str(this_collided_with)
		if ":" in this_collided_with:
			this_collided_with = this_collided_with.split(":")[0]
		handle_collision(collided, velocity.x, velocity.y, this_collided_with)		
	# =================================#

	input_vector.x = Input.get_action_strength("Thrust")
	
	if Input.is_action_pressed("Thrust"):
		global.player_energy -= 0.001 # decide what if any impact thrust has on energy
		$Thrust_Manager.thrust_pressed()
		#if !player_is_thrusting:
			#player_is_thrusting = true
			#$hud.thrust_pressed()
					
	if Input.is_action_just_released("Thrust"):
		$Thrust_Manager.thrust_released()
		$hud.thrust_released()
		player_is_thrusting = false
		
	
	$hud.show_velocity(velocity.x, velocity.y, delta)
	
	# background global.player_energy replenishment	
	global.player_energy_replenish()
	


func handle_collision(collided, speed_x, speed_y, this_collided_with):
	# ______________________________________________
	# collision penalty imposed for all collisions -
	# with everything that can be collided with    - 
	# not just the 'World' environment             -  
	# ______________________________________________
	var collision_strength = 'collision_soft'
	var damage = 1 # minimum amount of damage from any collision
	if speed_x >= 50 or speed_y >= 50:
		collision_strength = 'collision_hard'		
	show_collision_particles()
	velocity = velocity.bounce(collided.get_normal())
	var collision_rotation_penalty: int = 1
	if rotation_direction == 1:
		rotation_direction = -collision_rotation_penalty
	elif rotation_direction == -1:
		rotation_direction = collision_rotation_penalty
	else:
		rotation_direction = collision_rotation_penalty
	# define all collision specials
	if this_collided_with == "enemy1":
		damage = 0.2
	if this_collided_with == "World1":
		damage = 5
	if this_collided_with == "Phantom":
		damage = 10
		velocity.x += velocity.x / 2
		velocity.y += velocity.y / 2
	global.taking_damage(damage)

	
func show_collision_particles():
	colliding_effect.emitting = true
	$Camera2D.shake_camera(2, 6.1, 'collision')
	
	
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
			
			
func picked_up(type = "default"):
	pickup_type = type
	# copy current values
	print(pickup_type, " pickup acquired <<<<<<<<<")
	if type == "speed":
		if !global.speed_pickup_active:
			acceleration *= 2
			max_speed *= 2
			global.speed_pickup_active = true
		elif global.speed_pickup_active:
			pickup_timer.stop()
			pickup_timer.wait_time = 50
		pickup_timer.start() # player always gets a fresh 50 seconds
	if type == "energy":
		global.player_energy = 100
		print("ENERGY NOW", global.player_energy)
	if type == "shield":
		print("SHIELD COLLECTED")
		if global.shield_active:
			pickup_timer.stop()
		global.shield_active = true
		shield_gfx.visible = true
		shield_collision_shape.set_deferred("disabled", false)
		animation_player.play("shields_up")
		pickup_timer.wait_time = 25
		pickup_timer.start() # player always gets a fresh 25 seconds
	if type == "two_bullets":
		firing_points = 2
		pickup_timer.wait_time = 25
		pickup_timer.start() # player always gets a fresh 25 seconds
	if type == "three_bullets":
		firing_points = 3
		pickup_timer.wait_time = 25
		pickup_timer.start() # player always gets a fresh 25 seconds
		
	

func _on_pickup_timer_timeout(): # design of func open for other types of pickup, e.g. shields
	print(pickup_type, " pickup effect EXPIRED >>>>>>>>>")
	if pickup_type == "speed":
		acceleration = acceleration / 2
		max_speed = max_speed / 2
		global.speed_pickup_active = false
	if pickup_type == "shield":
		shield_gfx.visible = false
		animation_player.stop()
		shield_collision_shape.set_deferred("disabled", true)
		global.shield_active = false
	if pickup_type == "two_bullets" or pickup_type == "three_bullets":
		firing_points = 1
		
func camera_letterbox_effect():
	print("CAMERA EFFECT TBD lol")
	
