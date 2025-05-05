extends Node2D

@onready var global = $/root/Global
@onready var effect_particles = $CPUParticles2D
@onready var next_pusher_possible_timer = $next_pusher_possible_timer

const enemy_basic = preload("res://scenes/enemy_1.tscn")
const enemy_pusher = preload("res://scenes/enemy_missile.tscn")

var amount_spawned = 0
var max_can_spawn = 100
var spawner_active = false	
var particles_on : bool = false
var pusher_spawned : bool = false

# notes: need proper differentiation between enemy types for effect_particles

func add_new_enemy():
	if spawner_active and amount_spawned < max_can_spawn:
		var which_enemy = Global.random_float_number(1.0, 10.0)
		if $"/root/Global".dev_enemies_on:
			if pusher_spawned:
				which_enemy = 1
			if which_enemy < 8.1:
				var enemy_instance = enemy_basic.instantiate()
				enemy_instance.scale.x = 0.2
				enemy_instance.scale.y = 0.2
				add_child(enemy_instance)
				amount_spawned += 1
				global.swarmers_active += 1
				$Timer.wait_time = 6.0
			else:
				var enemy_instance = enemy_pusher.instantiate()
				add_child(enemy_instance)
				amount_spawned += 1	
				pusher_spawned = true
				next_pusher_possible_timer.start()
				$Timer.wait_time = 16.0
		for n in 8000:
			if n % 100 == 0:
				if effect_particles.amount >= 2:
					effect_particles.amount -= 1
		effect_particles.emitting = false
		particles_on = false	
		$Timer.start()


func _on_timer_timeout():
	if particles_on:
		add_new_enemy()
	else:
		effect_particles.amount = 2
		effect_particles.emitting = true
		particles_on = true
		$Timer.wait_time = 3.0
		$Timer.start()
		for n in 8000:
			if n % 100 == 0:
				if effect_particles.amount < 80:
					effect_particles.amount += 1


func _on_visible_on_screen_notifier_2d_screen_entered():
	spawner_active = true
	add_new_enemy()


func _on_visible_on_screen_notifier_2d_screen_exited():
	spawner_active = false
	effect_particles.emitting = false


func _on_next_pusher_possible_timer_timeout():
	pusher_spawned = false
	# can spawn pusher again (if spawnpoint active)
