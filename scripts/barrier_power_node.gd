extends Area2D

@onready var recharge_timer = $recharge_timer
@onready var global = $/root/Global

var hp = 100

func _process(delta):
	if hp > 0:
		rotation += 0.2
	if hp <= 0:
		global.barrier_energy -= 1
		recharge_timer.start()
		
func _on_area_entered(area):
	if area.name == "bullet":
		hp -= 10 # for test & debug only

func _on_recharge_timer_timeout():
	global.barrier_energy += 1
	hp = 100
