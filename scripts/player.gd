extends CharacterBody2D

@onready var acceleration = 40 # was 40 or 20
@onready var max_speed = 80 # was 100 or 40
@onready var gravity = 0 # 0 = FULL WEIGHTLESSNESS
@onready var rotation_speed = 4 # 5 or 3
@onready var global = $/root/Global
@onready var colliding_effect = $collision_particles
@onready var pickup_timer = $pickup_timer
@onready var shield_collision_shape = $shield_collision_shape
@onready var shield_gfx = $shield_gfx
@onready var animation_player = $AnimationPlayer
@onready var camera_2d = $Camera2D
@onready var pewpewpew = $pewpewpew
@onready var camera_timer: Timer = $camera_timer

# =============== SHOOTING
const bullet = preload("res://scenes/bullet.tscn")
var player_is_shooting := false # toggle to prevent continuous fire
@onready var firing_points = 4
# TESTING WITH 4 - usually 1, i.e. start only able to shoot from tip of craft
# ========================
@onready var energy_replenish_amount = global.player_energy_replenish_amount
var input_vector : Vector2
var rotation_direction: int
var energy_warning_shown = false
var player_is_thrusting = false
var thrusting_for = 0
var collided_with : String = ""
var pickup_type : String = ""
var pickup_active = false

var light_damage_taken : int = 90 # for testing purposes; will be 20 or 25 in final
var heavy_damage_taken : int = 70
var damage_light_animation_playing : bool = false
var damage_heavy_animation_playing : bool = false

var dynamic_zoom_in : bool = false
var camera_is_zooming : bool = false


func _physics_process(delta):
	if (velocity.x > 20 or velocity.x < -20 or velocity.y > 20 or velocity.y < -20) and dynamic_zoom_in and not camera_is_zooming:
		dynamic_zoom_in = false
		camera_is_zooming = true
		camera_2d.dynamic_zoom("out")
		camera_timer.start()
	if (velocity.x < 20 or velocity.x < -20 or velocity.y > 20 or velocity.y < -20) and not dynamic_zoom_in and not camera_is_zooming:
		dynamic_zoom_in = true
		camera_is_zooming = true
		camera_2d.dynamic_zoom("in")
		camera_timer.start()
	$hud.show_energy(global.player_energy)
	# always check on status of damage animations if energy < light damage
	if global.player_energy <= light_damage_taken:
		check_damage()
		
	# if one of the damage animations is playing, check that the player energy is still
	if damage_light_animation_playing or damage_heavy_animation_playing:
		# first check the light animation
		if damage_light_animation_playing:
			# stop the animation if not in range
			if global.player_energy > light_damage_taken or global.player_energy <= heavy_damage_taken:
				animation_player.speed_scale = 1
				animation_player.stop()
				damage_light_animation_playing = false
		if damage_heavy_animation_playing:
			# stop the animation if not in range
			if global.player_energy > heavy_damage_taken:
				animation_player.speed_scale = 1
				animation_player.stop()
				damage_heavy_animation_playing = false
		
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
		if !player_is_thrusting:
			player_is_thrusting = true
			#$hud.thrust_pressed()
					
	if Input.is_action_just_released("Thrust"):
		$Thrust_Manager.thrust_released()
		$hud.thrust_released()
		player_is_thrusting = false
		
	
	$hud.show_velocity(velocity.x, velocity.y, delta)
	
	# background global.player_energy replenishment	
	global.player_energy_replenish()
	
func dynamic_zoom(zoom_direction = "out"):
	pass
	

func handle_collision(collided, speed_x, speed_y, this_collided_with):
	# ______________________________________________
	# collision penalty imposed for all collisions -
	# with everything that can be collided with    - 
	# not just the 'World' environment             -  
	# ______________________________________________
	var damage = 1 # minimum amount of damage from any collision	
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
	print(this_collided_with)
	if this_collided_with == "enemy1":
		damage = 0.2
	if this_collided_with == "World1":
		damage = 5
	if this_collided_with == "Phantom":
		damage = 10
	if this_collided_with == "barrier":
		damage = 25
		if global.player_energy <= 70:
			damage += (100 - global.player_energy)
	if this_collided_with.begins_with("enemy_missile"):
		print("EDGE OF HUNTER")
		damage = 100
	velocity.x -= velocity.x / 10
	velocity.y -= velocity.y / 10
	global.taking_damage(damage)

	
func show_collision_particles():
	colliding_effect.emitting = true
	$Camera2D.shake_camera(2, 6.1, 'collision')
	
	
func shoot_bullets():
	pewpewpew.play()
	var times_fired = 0
	var firing_sparkle = $collision_particles
	for n in $firing_points.get_children():
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = n.global_position
		
		# Account for the player sprite being oriented at 90 degrees by default
		if firing_points == 1:
			# Single firing point - forward direction
			bullet_instance.rotation = rotation - PI/2
		elif firing_points == 4:
			# Multiple firing points - each in its own direction relative to player
			match times_fired:
				0: # Top firing point - shoots in the direction the player is facing (90° offset)
					bullet_instance.rotation = rotation - PI/2
				1: # Left firing point - shoots 90° counter-clockwise from player facing (0° offset)
					bullet_instance.rotation = rotation + PI
				2: # Right firing point - shoots 90° clockwise from player facing (180° offset)
					bullet_instance.rotation = rotation - PI * 2
				3: # Rear firing point - shoots opposite to player facing (270° offset)
					if player_is_thrusting:
						break
					bullet_instance.rotation = rotation + PI/2
		
		get_parent().add_child(bullet_instance)
		times_fired += 1
		if firing_points == 1:
			break
			
			
func picked_up(type = "default"):
	# player can only have one powerup at any one time!
	# if player picks up a new powerup it cancels the effect of the previous
	# if new pickup is same type as old it starts the timer again
	if pickup_active: # cancel current pickup if one already active
		_on_pickup_timer_timeout(true) # call pickup cancel func with true condition for current pickup
	# copy current values
	pickup_type = type
	pickup_active = true
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
	if type == "shield":
		if global.shield_active:
			pickup_timer.stop()
		global.shield_active = true
		shield_gfx.visible = true
		shield_collision_shape.set_deferred("disabled", false)
		animation_player.play("shields_up")
		pickup_timer.wait_time = 25
		pickup_timer.start() # player always gets a fresh 25 seconds
	if type == "three_bullets":
		firing_points = 4
		pickup_timer.wait_time = 25
		pickup_timer.start() # player always gets a fresh 25 seconds
		
	

func _on_pickup_timer_timeout(cancelling_current_pickup : bool = false): # design of func open for other types of pickup, e.g. shields
	if !cancelling_current_pickup:
		pickup_active = false
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
	
func check_damage():
	if global.player_energy > heavy_damage_taken and !damage_light_animation_playing:
		animation_player.play("damage_light")
		damage_heavy_animation_playing = false
		damage_light_animation_playing = true
	if global.player_energy <= heavy_damage_taken and !damage_heavy_animation_playing:
		animation_player.speed_scale = 3
		animation_player.play("damage_light")
		damage_light_animation_playing = false
		damage_heavy_animation_playing = true


func _on_camera_timer_timeout() -> void:
	camera_is_zooming = false
