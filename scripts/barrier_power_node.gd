extends Area2D

@onready var recharge_timer = $recharge_timer
@onready var global = $/root/Global

var hp = 100
var node_enabled = false

func _process(delta):
	if !node_enabled:
		return
	if hp > 0:
		rotation += 0.2
	if hp <= 0 and node_enabled:
		node_enabled = false
		global.barrier_energy -= 1
		print(global.barrier_energy)
		recharge_timer.start()
		
func _on_area_entered(area):
	if area.name == "bullet":
		hp -= 10 # for test & debug only

func _on_recharge_timer_timeout():
	if global.barrier_energy < 2:
		global.barrier_energy += 1
	print(global.barrier_energy)
	node_enabled = true
	hp = 100


func _on_visible_on_screen_enabler_2d_screen_entered():
	node_enabled = true


func _on_visible_on_screen_enabler_2d_screen_exited():
	hp = 100
	node_enabled = false
