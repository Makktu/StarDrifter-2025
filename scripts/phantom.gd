extends CharacterBody2D
# Enemy behaviour:
# dormant & phased out when not on-screen
# triggered into cycle by VisibleOnScreenEnabler
# resumes dormant/phased out state when not on-screen
# always rotates to face the player
# phases in and fires laser directly ahead for 3 seconds every 6 seconds
# after taking a certain amount of damage, phases out for 15 seconds to 'recharge'
# is only vulnerable from rear
# ==============================================================================
var laser_beam = preload("res://scenes/phantom_laser.tscn")
var phased_out = true
var time_to_next_phase_in = 4.0 # time in seconds to next appearance on map
@onready var phase_timer = $PhaseTimer
@onready var fire_timer = $FireTimer
@onready var laser_spawn = $LaserSpawn
@onready var sprite = $Sprite2D
@onready var the_player = get_tree().get_nodes_in_group("player")[0]
@onready var collision_shape = $CollisionShape2D
var enemy_speed = 10
var rotation_speed = 2.0  # smoother tracking
var phantom_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# start with sprite invisible
	sprite.modulate.a = 0.0
	# create tween to fade in sprite after X seconds	
	phase_timer.start()

	
func _physics_process(delta):
	if phantom_active: # if phantom is not on-screen, phantom is inert	
		var direction = global_position.direction_to(the_player.global_position)
		# Only handle rotation when phased in
		if !phased_out:
			var target_angle = direction.angle()
			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
		velocity = direction * enemy_speed * delta	
		var collided := move_and_collide(velocity * delta)
		if collided:
			var collided_with = collided.get_collider()
			if collided_with is CharacterBody2D:
				var instance_name = str(collided_with).split("<")[0].split(":")[0]
				print("phantom reporting:", instance_name)
							
	
func fade_in():
	# create Tween object
	var tween = get_tree().create_tween()
	# Fade in the sprite by tweening the alpha value of its modulate property
	tween.tween_property(
		sprite, 
		"modulate:a", 
		1.0,       # Target alpha value
		5.0,       # Duration in seconds
		).set_ease(Tween.EASE_IN_OUT)
	phased_out = false
	collision_shape.disabled = false
	fire_timer.start()

	
func fade_out():
	# create Tween object
	var tween = get_tree().create_tween()
	# Tween the alpha value back to 0
	tween.tween_property(
		sprite, 
		"modulate:a", 
		0.0,  # Target alpha
		5.0   # Duration in seconds
		).set_ease(Tween.EASE_IN_OUT)
	phased_out = true
	var random_phase_out_time = randi_range(8, 24)
	phase_timer.wait_time = random_phase_out_time
	print(">>>", random_phase_out_time)
	phase_timer.start()
	collision_shape.disabled = true
	fire_timer.stop()


func _on_phase_timer_timeout():
	# phases in upon entering screen
	if !phantom_active:
		fade_in()
	else:
		fade_out()


func _on_visible_on_screen_enabler_2d_screen_entered():
	print("PHANTOM ACTIVE")
	phase_timer.start()


func _on_visible_on_screen_enabler_2d_screen_exited():
	print("PHANTOM INACTIVE")
	phantom_active = false
	phase_timer.start()


func _on_fire_timer_timeout():
	if !phased_out:
		var new_laser = laser_beam.instantiate()
		add_child(new_laser)
		fire_timer.start() # keep firing at regular intervals until phased out
