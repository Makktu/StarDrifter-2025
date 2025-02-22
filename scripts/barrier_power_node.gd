extends Area2D

@onready var recharge_timer = $recharge_timer
@onready var global = $/root/Global
@onready var particles = $CPUParticles2D

var generator_node: Node2D # SPECIAL

var hp = 100
var node_enabled = false

func _process(delta):
	if generator_node and particles.emitting:
		# Calculate direction to generator
		var direction = generator_node.global_position - global_position
		# Normalize and set as the particles' direction
		particles.direction = direction.normalized()
	if !node_enabled:
		return
	if hp > 0:
		rotation += 0.2
	if hp <= 0 and node_enabled:
		node_enabled = false
		global.barrier_energy -= 1
		print(global.barrier_energy)
		recharge_timer.start()
		
func find_nearest_generator():
	var generators = get_tree().get_nodes_in_group("barrier_generators")
	var closest_distance = INF
	
	for generator in generators:
		var distance = global_position.distance_to(generator.global_position)
		if distance < closest_distance:
			closest_distance = distance
			generator_node = generator

		
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
	find_nearest_generator()
	particles.emitting = true
	node_enabled = true


func _on_visible_on_screen_enabler_2d_screen_exited():
	hp = 100
	particles.emitting = false
	node_enabled = false
