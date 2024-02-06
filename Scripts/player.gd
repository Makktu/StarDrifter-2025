extends CharacterBody2D

@onready var acceleration = 60 #30
@onready var max_speed = 100
@onready var gravity = 0 #0 FOR FULL WEIGHTLESSNESS
@onready var rotation_speed = 5 #6
@onready var starting_energy = 100

signal energy_change

var input_vector : Vector2
var rotation_direction: int

var energy_warning_shown = false

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
	var collided := move_and_slide()
	if collided and not get_floor_normal():
		var slide_direction := get_last_slide_collision().get_normal()
		velocity = velocity.slide(slide_direction)

	input_vector.x = Input.get_action_strength("Thrust")
	
	if Input.is_action_pressed("Thrust"):
		$AnimatedSprite2D.visible = true
		$AnimatedSprite2D.play()
		starting_energy -= 0.05
		emit_signal("energy_change", starting_energy)
		
	if Input.is_action_just_released("Thrust"):
		$AnimatedSprite2D.visible = false
		$AnimatedSprite2D.stop()
	
	$hud.show_velocity(velocity.x, velocity.y, delta)
		
	if starting_energy < 9500 and !energy_warning_shown:
		energy_warning_shown = true
		$hud.show_warning()
			
