extends Node2D

@onready var effect_particles = $CPUParticles2D
@onready var main_timer = $main_timer # timer for pusher spawn timings
@onready var anim_timer = $anim_timer # timer that for appearance animation
@onready var spawning_lines = $Sprite2D2

const enemy_pusher = preload("res://scenes/enemy_missile.tscn")

var amount_spawned = 0
var max_can_spawn = 100
var spawner_active = false	


func add_new_enemy():
	if spawner_active and amount_spawned < max_can_spawn:
		if $"/root/Global".dev_enemies_on:
			var enemy_instance = enemy_pusher.instantiate()
			#enemy_instance.scale.x = 0.2
			#enemy_instance.scale.y = 0.2
			add_child(enemy_instance)
			amount_spawned += 1
			Global.swarmers_active += 1
			main_timer.wait_time = (20 - Global.global_difficulty) # default global difficulty is 1
		main_timer.start()
				

func _on_timer_timeout():
	embiggen()
	anim_timer.start()
	

func _on_visible_on_screen_notifier_2d_screen_entered():
	embiggen()
	anim_timer.start()
	spawner_active = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	spawner_active = false
	
	
func embiggen():
	var current_scale = spawning_lines.scale.x
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	# will only be expanding in size with each speed/power increase
	var target_animation = spawning_lines
	tween.tween_property(
		target_animation, 
		"scale",
		Vector2(current_scale + 0.15, current_scale + 0.15),
		0.5   # Duration in seconds
		)
	tween.tween_property(
		target_animation, 
		"scale",
		Vector2(current_scale, current_scale),
		0.01   # Duration in seconds
		)
	tween.set_loops(3)	


func _on_main_timer_timeout():
	embiggen()
	anim_timer.start()


func _on_anim_timer_timeout():
	add_new_enemy()
