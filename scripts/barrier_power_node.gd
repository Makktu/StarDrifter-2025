extends Area2D

@onready var particles = $CPUParticles2D

var hp : int = 100
var node_enabled : bool = false
var node_interruption_active : bool = false
var rotation_speed : float = 0.2 # rotation speed when hp at 100

func _process(delta):
	if node_enabled:
		rotation += rotation_speed	
	if node_interruption_active and Global.barrier_energy: # ending the interruption
		node_interruption_active = false
		rotation_speed = 0.2
		particles.emitting = true		
		
func _on_area_entered(area):
	if area.name == "bullet":
		hp -= 100 # for test & debug only
		
		# check if node power reduced and barrier interrupted
		if hp <= 0 and Global.barrier_energy: # only activates once
			node_interruption_active = true
			rotation_speed = 0.05
			particles.emitting = false
			Global.barrier_energy = false


func _on_visible_on_screen_enabler_2d_screen_entered():
	if !node_interruption_active:
		node_enabled = true
		particles.emitting = true


func _on_visible_on_screen_enabler_2d_screen_exited():
	if !node_interruption_active:
		node_enabled = false
		particles.emitting = false
