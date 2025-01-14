extends CharacterBody2D

@export var deathBlowUp : PackedScene
@onready var the_player = get_tree().get_nodes_in_group("player")[0]
@onready var global = $/root/Global

var enemy_speed = 12
var target_position
var rotation_speed = 0.1
var this_enemy_shot := 0
var this_enemy_killed_at := 3
var this_enemy_onscreen = false
var player_in_range = false
var extinction_triggered = false
var extinction_timer_value = 2
var distance_from_player
var alerted_distance_from_player: int = 200

func _physics_process(delta):
	#if $"/root/Global".smart_bomb_active and this_enemy_onscreen:
		#_on_extinction_timer_timeout()
	rotation_degrees += rotation_speed
	var direction = global_position.direction_to(the_player.global_position)
	velocity = direction * enemy_speed * delta
	move_and_collide(velocity)
	
	#if player_in_range and rotation_speed < 4:
		#rotation_speed += 0.1			
	
	var collided := move_and_collide(velocity * delta)
	if collided and rotation_speed <= 4:
		rotation_speed += 0.25
		
	var player_position = the_player.global_position
	var mine_position = global_transform.origin
	distance_from_player = player_position.distance_to(mine_position)
	if distance_from_player < 300 and !player_in_range:
		player_in_range = true
		rotation_speed += 3
	if distance_from_player >= 300 and player_in_range:
		player_in_range = false
		rotation_speed = 0.1
	if distance_from_player < 20 and !extinction_triggered:
		enemy_speed *= 2
		extinction_triggered = true
		$ExtinctionTimer.wait_time = extinction_timer_value
		rotation_speed += 6
		#enemy_speed = 150
		$ExtinctionTimer.start()


func _on_bullet_area_area_entered(area):
	if area.name == 'bullet':
		this_enemy_shot += 1
		if this_enemy_shot >= this_enemy_killed_at:
			rotation_speed = 0
			$explosion.visible = true
			$Sprite2D.visible = false
			$explosion.play('explode')

func _on_explosion_animation_finished():
	$"/root/Global".enemy_basic_in_world -= 1
	if distance_from_player < 12:
		$"/root/Global".damage_player(distance_from_player)
	queue_free()


func _on_life_timer_timeout():
	$"/root/Global".enemy_basic_in_world -= 1
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	this_enemy_onscreen = false
	$LifeTimer.start()


func _on_visible_on_screen_notifier_2d_screen_entered():
	this_enemy_onscreen = true
	$LifeTimer.stop()


func _on_extinction_timer_timeout():
	rotation_speed = 0
	var _explosion = deathBlowUp.instantiate()
	_explosion.position = global_position
	_explosion.rotation = global_rotation
	_explosion.emitting = true
	get_tree().current_scene.add_child(_explosion)
	if player_in_range:
		print("Swarmer hit")
		global.taking_damage(20)
	queue_free()
	
