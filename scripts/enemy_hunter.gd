extends CharacterBody2D

@onready var the_player = get_tree().get_nodes_in_group("player")[0]

var hunter_active : bool = false
var speed = 30
var proximity = 0.005
var player_position
var hunter_position
var distance_from_player
@onready var timer = $Timer

func _physics_process(delta):
	if hunter_active:
		var direction = global_position.direction_to(the_player.global_position)
		velocity = direction * speed * delta
		move_and_collide(velocity)
		rotation += proximity
		hunter_position = global_transform.origin
		player_position = the_player.global_position
		distance_from_player = player_position.distance_to(hunter_position)
		if distance_from_player <= 230:
			if proximity >= 0.005:
				if proximity < 0.05:
					proximity += 0.0025
		if distance_from_player > 230 and proximity > 0.005:
			proximity -= 0.0025
			if proximity < 0.005:
				proximity = 0.005
		if distance_from_player < 20:
			Global.taking_damage(10)
		if Input.is_action_just_released("query"):
			print(distance_from_player, proximity)

func _on_visible_on_screen_notifier_2d_screen_entered():
	# enemy is activated by appearing on-screen & then 
	# remains permanently active - will pursue player across map until destroyed
	# only 1 hunter active at a time
	if Global.hunters_active == 0:
		hunter_active = true
		Global.hunters_active = 1
		timer.start() # increase speed by 1 every ~30 seconds (TBD) - the player is not safe no matter how distant


func _on_timer_timeout():
	if speed < 80:
		speed += 1
	timer.start()
	
