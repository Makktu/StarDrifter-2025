extends Area2D

@onready var recharge_timer = $recharge_timer
@onready var global = $/root/Global
@onready var particles = $CPUParticles2D

var hp = 100
var node_enabled = false
var rotation_speed = 0.2 # rotation speed when hp at 100

func _process(delta):
	if node_enabled:
		rotation += rotation_speed
		if hp <= 0 and global.barrier_energy:
			rotation_speed = -0.05
			global.barrier_energy = false
			particles.emitting = false
			recharge_timer.start()

		
func _on_area_entered(area):
	if area.name == "bullet":
		rotation_speed -= 0.01
		hp -= 20 # large chunk for test & debug only

func _on_recharge_timer_timeout():
	particles.emitting = true
	await get_tree().create_timer(2.0).timeout
	global.barrier_energy = true
	rotation_speed = 0.2
	hp = 100
	global.barrier_energy = true
	node_enabled = true
	recharge_timer.wait_time = 8.0


func _on_visible_on_screen_enabler_2d_screen_entered():
	node_enabled = true
	particles.emitting = true


func _on_visible_on_screen_enabler_2d_screen_exited():
	hp = 100
	node_enabled = false
	particles.emitting = false
