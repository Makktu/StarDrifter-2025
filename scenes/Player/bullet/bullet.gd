extends StaticBody2D

@onready var explosion_frames = $explosion

var speed = 250
var exploded_again := false

var velocity = Vector2(0, speed)

func _ready():
	velocity = velocity.rotated(deg_to_rad(global_rotation_degrees))

	
func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		$Sprite2D.visible = false
		$collision_particles.emitting = true
	rotation_degrees += 3


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_explosion_animation_finished():
	# randomly have an extra explosion
	if !exploded_again:
		if $"/root/Global".random_float_number(1, 5) > 2.5:
			explosion_frames.play("explode")
			exploded_again = true
	# finally, remove bullet from world
	queue_free()


func _on_collision_particles_finished():
	queue_free()
