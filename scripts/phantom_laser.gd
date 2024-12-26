extends Node2D

@onready var ray_cast = $RayCast2D
@onready var line_2d = $Line2D

const LASER_LENGTH = 3000  # Increased length for better reach

func _ready():
	# Set up initial length
	ray_cast.target_position = Vector2(LASER_LENGTH, 0)
	line_2d.points[1] = Vector2(LASER_LENGTH, 0)
	
	# Force the raycast to update immediately
	ray_cast.force_raycast_update()
	shoot_laser()
	# Queue free after brief display
	await get_tree().create_timer(0.2).timeout
	queue_free()

func shoot_laser():
	# Get the collision point or use full length if no collision
	var end_point = ray_cast.get_collision_point() if ray_cast.is_colliding() else ray_cast.global_position + ray_cast.target_position
	
	# Convert the end point to local coordinates if it's a collision point
	if ray_cast.is_colliding():
		end_point = to_local(end_point)
		var collider = ray_cast.get_collider()
		print(collider)
		if collider.is_in_group("player"):
			print("PLAYER HIT")
	else:
		end_point = Vector2(LASER_LENGTH, 0)
	
	# Update the line end point
	line_2d.points[1] = end_point
	
	# Handle collision effects
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(10)  # Damage amount
