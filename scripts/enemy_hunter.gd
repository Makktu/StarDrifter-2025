extends CharacterBody2D

@onready var the_player = get_tree().get_nodes_in_group("player")[0]
@onready var timer = $Timer
@onready var animated_sprite = $AnimatedSprite2D
@onready var hunter_timer = $Timer2
@onready var animation_player = $AnimationPlayer
@onready var explosion = $explosion
@onready var sprite_2d = $Sprite2D

var hunter_active : bool = false
var speed = 30
var proximity = 0.005
var player_position
var hunter_position
var distance_from_player
var hunter_death : bool = false

func _physics_process(delta):
	if hunter_active:
		var direction = global_position.direction_to(the_player.global_position)
		velocity = direction * speed * delta
		var collided := move_and_collide(velocity)
		if collided and not get_floor_normal():
			var this_collided_with = collided.get_collider()
			this_collided_with = str(this_collided_with)
			print("HUNTER COLLISION: ", this_collided_with)
			if ":" in this_collided_with:
				this_collided_with = this_collided_with.split(":")[0]
				if this_collided_with == "barrier" and not hunter_death:
					hunter_timer.start()
					proximity = 0
					hunter_death = true
					animation_player.play("hunter_death")
		rotation += proximity
		hunter_position = global_transform.origin
		player_position = the_player.global_position
		distance_from_player = player_position.distance_to(hunter_position)
		if distance_from_player <= 230:
			if not animated_sprite.visible:
				animated_sprite.visible = true
			if animated_sprite.speed_scale == 0.7:
				animated_sprite.speed_scale = 1.2
			if proximity >= 0.005:
				if proximity < 0.05:
					proximity += 0.0025
		if distance_from_player > 230 and proximity > 0.005:
			if animated_sprite.visible:
				animated_sprite.visible = false
			if animated_sprite.speed_scale == 1.2:
				animated_sprite.speed_scale = 0.7
			proximity -= 0.0025
			if proximity < 0.005:
				proximity = 0.005
		if distance_from_player < 20:
			Global.taking_damage(10)
		if Input.is_action_just_released("query"):
			print(distance_from_player, proximity)

func _on_visible_on_screen_notifier_2d_screen_entered():
	if Global.hunters_active < Global.max_hunters_active:
		hunter_active = true
		Global.hunters_active += 1
		timer.start() # increase speed by 1 every 5 seconds (for testing purposes) - the player is not safe no matter how distant
		animated_sprite.play("default")
		

func embiggen():
	var current_scale = scale.x
	var tween = get_tree().create_tween()
	# will only be expanding in size with each speed/power increase
	tween.tween_property(
		self, 
		"scale",
		Vector2(current_scale + 0.25, current_scale + 0.25),
		2.0   # Duration in seconds
		).set_ease(Tween.EASE_IN_OUT)

func _on_timer_timeout():
	# increases hunter speed every [timer] seconds
	if speed < 80:
		speed += 1
		embiggen() 	# expanding in size with each speed/power increase
	timer.start()	
			

func _on_timer_2_timeout():
	hunter_active = false
	proximity = 0
	$explosion.visible = true
	$explosion.play('explode')
	animated_sprite.visible = false
	sprite_2d.visible = false
	Global.hunters_vanquished += 1
	Global.max_hunters_active += 1


func _on_explosion_animation_finished():
	queue_free()	
	Global.hunters_active -= 1 # update global hunter count
