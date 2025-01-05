extends Node2D

@onready var ray_cast = $RayCast2D
@onready var line_2d = $Line2D
@onready var global = $/root/Global

const LASER_LENGTH = 3000

func _ready():
	# Configure raycast for better performance
	ray_cast.target_position = Vector2(LASER_LENGTH, 0)
	ray_cast.collision_mask = 5  # Updated to match player's collision layer
	line_2d.points[1] = Vector2(LASER_LENGTH, 0)
	
	# Update and shoot immediately
	ray_cast.force_raycast_update()
	shoot_laser()
	
	# Queue free after display
	await get_tree().create_timer(3.0).timeout
	queue_free()

func shoot_laser():
	if ray_cast.is_colliding():
		var collision_point = ray_cast.get_collision_point()
		var collider = ray_cast.get_collider()
		
		# Update visual laser length to collision point
		line_2d.points[1] = to_local(collision_point)
		
		# Handle player collision efficiently
		if collider.is_in_group("player"):
			print("PLAYER HIT!")
			#global.player_damage = true
	else:
		# No collision - extend to full length
		line_2d.points[1] = Vector2(LASER_LENGTH, 0)
