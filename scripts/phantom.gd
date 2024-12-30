extends CharacterBody2D

var laser_beam = preload("res://scenes/phantom_laser.tscn")
# Enemy notes:
# completely dormant when not on screen
# triggered by VisibleOnScreenEnabler
# phases in and fires laser directly ahead every 4 seconds, a total of 8 times, while rotating to face the player
# phases out for a random length of time to 'recharge'
# phases out when leaving screen
# is only vulnerable from rear


var phased_out = true
var time_to_next_phase_in = 4.0 # time in seconds to next appearance on map
@onready var phase_timer = $PhaseTimer
@onready var fire_timer = $FireTimer
@onready var laser_spawn = $LaserSpawn
@onready var off_screen_timer = $OffScreenTimer
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var the_player = get_tree().get_nodes_in_group("player")[0]
@onready var collision_shape = $CollisionShape2D


var enemy_speed = 10
var target_position
var rotation_speed = 2.0  # smoother tracking
var this_enemy_shot := 0
var this_enemy_killed_at := 3
var this_enemy_onscreen = false
var player_in_range = false
var extinction_triggered = false
var extinction_timer_value = 2
var distance_from_player
var phantom_active = false
var fired_laser = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# start with sprite invisible
	sprite.modulate.a = 0.0
	# create tween to fade in sprite after X seconds	
	phase_timer.start()
	fire_timer.start()
	
func _physics_process(delta):
	if phantom_active: # if phantom is not on-screen, phantom goes inert	
		var direction = global_position.direction_to(the_player.global_position)
		# Only handle rotation when phased in
		if !phased_out:
			var target_angle = direction.angle()
			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
		velocity = direction * enemy_speed * delta
		move_and_collide(velocity)
	
		var collided := move_and_collide(velocity * delta)
		if collided:
			if phased_out:
				fade_in()
			if rotation_speed <= 4: rotation_speed += 0.2				
	
func fade_in():
	fired_laser = 0
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
	if phased_out:
		fade_in()
	else:
		fade_out()


func _on_visible_on_screen_enabler_2d_screen_entered():
	phantom_active = true
	print("PHANTOM ACTIVE")
	phase_timer.start()

func _on_visible_on_screen_enabler_2d_screen_exited():
	# keeping the Phantom alive and shooting for 5s after off-screen
	off_screen_timer.start()


func _on_fire_timer_timeout():
	if !phased_out:
		var new_laser = laser_beam.instantiate()
		add_child(new_laser)
		fire_timer.start()
		fired_laser += 1
		if fired_laser == 8:
			fade_out()


func _on_off_screen_timer_timeout():
	print("PHANTOM INACTIVE")
	phantom_active = false
	fade_out()
