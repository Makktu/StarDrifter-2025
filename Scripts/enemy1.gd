extends CharacterBody2D

@onready var the_player = get_tree().get_nodes_in_group("player")[0]



var enemy_speed = 5
var target_position
var rotation_speed = 0.1

var this_enemy_shot = false

#func _ready():
	#print("spawned at", position.x, " ", position.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation_degrees += rotation_speed
	var direction = global_position.direction_to(the_player.global_position)
	velocity = direction * enemy_speed * delta
	move_and_collide(velocity)
	
	var collided := move_and_collide(velocity * delta)
	if collided:
		handle_collision(collided)
		
func handle_collision(collided):
	rotation_speed += 0.1


func _on_detect_bullets_body_entered(body):
	print(body)
