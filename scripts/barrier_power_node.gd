extends Area2D

@onready var particles = $CPUParticles2D

var hp : int = 100
var node_enabled : bool = false
var rotation_speed : float = 0.2 # rotation speed when hp at 100

func _process(delta):
	if node_enabled:
		rotation += rotation_speed			
		
func _on_area_entered(area):
	if area.name == "bullet":
		hp -= 100 # for test & debug only		
		# check if node power reduced and barrier interrupted
		if hp <= 0 and Global.barrier_energy: # only activates once
			Global.barrier_energy = false
			Global.barrier_timer.start()
			rotation_speed = 0.05
			particles.emitting = false


func _on_visible_on_screen_enabler_2d_screen_entered():
	if Global.barrier_energy:
		node_enabled = true
		particles.emitting = true


func _on_visible_on_screen_enabler_2d_screen_exited():
	if !Global.barrier_energy:
		return
	else:
		node_enabled = false
		particles.emitting = false
