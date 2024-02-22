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
		explosion_frames.visible = true
		var tweak_scale = $"/root/Global".random_float_number(-1, 2)
		explosion_frames.scale.x += tweak_scale
		explosion_frames.scale.y += tweak_scale
		explosion_frames.play("explode")
		#velocity = velocity.bounce(collision_info.get_normal())
		#var collided_with = collision_info
		#print(collided_with)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_explosion_animation_finished():
	if !exploded_again:
		if $"/root/Global".random_float_number(1, 5) > 2.5:
			explosion_frames.play("explode")
			print('exploded again?')
			exploded_again = true
	queue_free()
