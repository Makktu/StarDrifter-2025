extends CharacterBody2D

@onready var the_player = get_tree().get_nodes_in_group("player")[0]

var enemy_speed = 50
var target_position
var rotation_speed = 0.1
var this_enemy_shot := 0
var this_enemy_killed_at := 3

func _physics_process(delta):
	rotation_degrees += rotation_speed
	var direction = global_position.direction_to(the_player.global_position)
	velocity = direction * enemy_speed * delta
	move_and_collide(velocity)
	
	var collided := move_and_collide(velocity * delta)
	if collided and rotation_speed <= 4:
		rotation_speed += 0.25


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
	queue_free()


func _on_life_timer_timeout():
	$"/root/Global".enemy_basic_in_world -= 1
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	$LifeTimer.start()


func _on_visible_on_screen_notifier_2d_screen_entered():
	$LifeTimer.stop()
