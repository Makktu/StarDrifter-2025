extends Node2D

@onready var ray_cast = $RayCast2D
@onready var line_2d = $Line2D
@onready var global = $/root/Global

@export var impact_particles: PackedScene


const LASER_LENGTH = 3000
var current_particle_effect: Node2D = null

func _ready():
	# Configure raycast for better performance
	ray_cast.target_position = Vector2(LASER_LENGTH, 0)
	ray_cast.collision_mask = 7  # Updated to match player's collision layer
	line_2d.points[1] = Vector2(LASER_LENGTH, 0)
	
	# Update and shoot immediately
	ray_cast.force_raycast_update()
	shoot_laser()
	
	# Queue free after display
	await get_tree().create_timer(3.0).timeout
	queue_free()
	
func _process(delta):
	# update raycast every frame
	ray_cast.force_raycast_update()
	shoot_laser()

func shoot_laser():
	if ray_cast.is_colliding():
		var collision_point = ray_cast.get_collision_point()
		var collider = ray_cast.get_collider()
		
		# Update visual laser length to collision point
		line_2d.points[1] = to_local(collision_point)
		
		# Handle particle effect at collision point
		if impact_particles:
			# Remove old particle effect if it exists
			if current_particle_effect:
				current_particle_effect.queue_free()
			
			# Create new particle effect
			current_particle_effect = impact_particles.instantiate()
			get_tree().get_root().add_child(current_particle_effect)
			current_particle_effect.global_position = collision_point
			# Ensure particles are emitting (in case auto-emission was changed in 4.4)
			if current_particle_effect.has_node("collision_particles"):
				current_particle_effect.get_node("collision_particles").scale.x = 0.2
				current_particle_effect.get_node("collision_particles").scale.y = 0.2		
		
				current_particle_effect.get_node("collision_particles").emitting = true
			
		# Get the actual node (either the collider or its parent)
		var hit_object = collider.get_parent() if collider.get_parent() else collider
		
		# Handle enemy collision
		if hit_object.is_in_group("enemy"):
			if hit_object.has_method("take_damage"):
				hit_object.take_damage()
		
		# Handle player collision efficiently
		if collider.get_parent().is_in_group("player"):
			global.taking_damage(global.base_damage / 10)
	else:
		# No collision - extend to full length
		line_2d.points[1] = Vector2(LASER_LENGTH, 0)
		# Remove particle effect if no collision
		if current_particle_effect:
			current_particle_effect.queue_free()
			current_particle_effect = null
