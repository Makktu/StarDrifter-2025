extends CharacterBody2D

@export var deathBlowUp : PackedScene
@onready var the_player = get_tree().get_nodes_in_group("player")[0]
@onready var global = $/root/Global
@onready var life_timer = $LifeTimer

var enemy_speed : float = 8.0
var enemy_speed_orig : int = enemy_speed
var max_enemy_speed : int = 64
var target_position
var rotation_speed : float = 0.1
var this_enemy_shot : int = 0
var this_enemy_killed_at : int = 3
var this_enemy_onscreen : bool = false
var player_in_range : bool = false
var extinction_triggered : bool = false
var extinction_timer_value : int = 2
var distance_from_player : float
var alerted_distance_from_player: int = 200

func _ready():
	if global.random_float_number(1, 10) > (10 - global.global_difficulty):
		# each spawner has random chance of being double speed
		# will always multiple base speed by global difficulty
		# (default = 1, so this will be 1 + 1 = 2, doubling it)
		enemy_speed *= (global.global_difficulty + 1)
		enemy_speed_orig = enemy_speed

func _physics_process(delta):
	#if $"/root/Global".smart_bomb_active and this_enemy_onscreen:
		#_on_extinction_timer_timeout()
	if global.swarmers_active > enemy_speed / 2 and enemy_speed <= max_enemy_speed:
		enemy_speed += 0.05
	rotation_degrees += rotation_speed
	var direction = global_position.direction_to(the_player.global_position)
	velocity = direction * enemy_speed * delta
	move_and_collide(velocity)			
	
	var collided := move_and_collide(velocity * delta)			
	if collided and rotation_speed <= 4:
		rotation_speed += 0.25
		
	var player_position = the_player.global_position
	var mine_position = global_transform.origin
	distance_from_player = player_position.distance_to(mine_position)
	if distance_from_player < 100 and !player_in_range:
		player_in_range = true
		rotation_speed += 3
		enemy_speed *= 2
	if distance_from_player >= 100 and player_in_range:
		player_in_range = false
		rotation_speed = 0.1
		enemy_speed = max_enemy_speed
	if distance_from_player < 35 and the_player.shield_collision_shape.disabled == false:
		_on_extinction_timer_timeout()
	if distance_from_player < 20 and !extinction_triggered:
		enemy_speed = enemy_speed_orig
		extinction_triggered = true
		$ExtinctionTimer.wait_time = extinction_timer_value
		rotation_speed += 6
		$ExtinctionTimer.start()


func _on_bullet_area_area_entered(area):
	print(area.name)
	if area.name == 'bullet':
		this_enemy_shot += 1
		if this_enemy_shot >= this_enemy_killed_at:
			rotation_speed = 0
			_trigger_explosion()
	elif area.get_parent().is_in_group("player"):
		var player = area.get_parent()
		if !player.shield_collision_shape.disabled:  # If shield is active
			_trigger_explosion()
	elif area.name == 'barrier_area':
		_on_extinction_timer_timeout()
		
			
func _trigger_explosion():
	rotation_speed = 0
	$explosion.visible = true
	$Sprite2D.visible = false
	$explosion.play('explode')

func _on_explosion_animation_finished():
	global.swarmers_active
	if distance_from_player < 12:
		global.damage_player(distance_from_player)
	queue_free()


func _on_life_timer_timeout():
	global.swarmers_active -= 1
	print("Global swarmers now: ", global.swarmers_active)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	this_enemy_onscreen = false
	life_timer.wait_time = 20
	life_timer.start()
	# 20s countdown for an off-screen swarmer to be removed from game


func _on_visible_on_screen_notifier_2d_screen_entered():
	this_enemy_onscreen = true
	life_timer.stop() # interrupts timer if enemy makes it back on-screen within 20s


func _on_extinction_timer_timeout():
	rotation_speed = 0
	var _explosion = deathBlowUp.instantiate()
	_explosion.position = global_position
	_explosion.rotation = global_rotation
	_explosion.emitting = true
	get_tree().current_scene.add_child(_explosion)
	if player_in_range:
		global.taking_damage(2)
	queue_free()
	
func take_damage():
	_on_extinction_timer_timeout()
