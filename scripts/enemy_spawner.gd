extends Node2D

@onready var cpu_particles_2d = $CPUParticles2D
@onready var global = $/root/Global
@onready var animation_player = $AnimationPlayer

const enemy_basic = preload("res://scenes/enemy_1.tscn")

var amount_spawned = 0
var max_can_spawn = 100
var spawner_active = false	
var pre_spawn_particles : bool = false

func add_new_enemy():	
	if spawner_active and amount_spawned < max_can_spawn:
		if $"/root/Global".dev_enemies_on:
			var enemy_instance = enemy_basic.instantiate()
			enemy_instance.scale.x = 0.2
			enemy_instance.scale.y = 0.2
			add_child(enemy_instance)
			amount_spawned += 1
			global.swarmers_active += 1
		$Timer.start()


func _on_timer_timeout():
	if amount_spawned > 3 and $Timer.wait_time != 3:
		$Timer.wait_time = (3 - global.global_difficulty)
	add_new_enemy()


func _on_visible_on_screen_notifier_2d_screen_entered():
	spawner_active = true
	animation_player.play("rotate")
	add_new_enemy()


func _on_visible_on_screen_notifier_2d_screen_exited():
	spawner_active = false
	animation_player.stop()
