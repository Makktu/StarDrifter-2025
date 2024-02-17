extends CharacterBody2D

@onready var acceleration = 60 #30
@onready var max_speed = 100
@onready var gravity = 0 #0 FOR FULL WEIGHTLESSNESS
@onready var rotation_speed = 5 #6
@onready var starting_energy = 100
@onready var global = $/root/Global

signal energy_change

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
		
	velocity += Vector2(input_vector.x * acceleration * delta, 0).rotated(rotation)
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	
	$Camera2D.dynamic_zoom(velocity.x, velocity.y)
	
	rotation += rotation_direction * rotation_speed * delta		
	var collided := move_and_collide(velocity * delta)
	if collided and not get_floor_normal():
		#var slide_direction := get_last_slide_collision().get_normal()
		velocity = velocity.bounce(collided.get_normal())
		if rotation_direction == 1:
			rotation_direction = -1
		elif rotation_direction == -1:
			rotation_direction = 1
		else:
			rotation_direction = 1

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
		
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var body := collision.get_collider()
		collided_with = body.name.left(5)
		if collided_with == 'World':
			print("GAME OVER")
		starting_energy -= 1
		emit_signal("energy_change", starting_energy)
		
func camera_special(type):
	if !type:
		return
	$Camera2D.zoom_special(type)
