extends Area2D

@onready var recharge_timer = $recharge_timer
@onready var global = $/root/Global

var hp = 100
var node_enabled = false
var rotation_speed = 0.2 # rotation speed when hp at 100

func _process(delta):
	if hp > 0:
		rotation += rotation_speed
	if hp <= 0 and node_enabled:
		node_enabled = false
		global.barrier_energy = false
		print(global.barrier_energy)
		recharge_timer.start()

		
func _on_area_entered(area):
	if area.name == "bullet":
		rotation_speed += 0.1
		hp -= 20 # large chunk for test & debug only

func _on_recharge_timer_timeout():
	global.barrier_energy = true
	node_enabled = true
	rotation_speed = 0.2
	hp = 100


func _on_visible_on_screen_enabler_2d_screen_entered():
	node_enabled = true


func _on_visible_on_screen_enabler_2d_screen_exited():
	hp = 100
	node_enabled = false
