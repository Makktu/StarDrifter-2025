extends Node2D

@onready var global = $/root/Global
@onready var effect_particles = $CPUParticles2D
@onready var next_pusher_possible_timer = $next_pusher_possible_timer
@onready var spawn_circles_timer = $spawn_circles_timer

const enemy_basic = preload("res://scenes/enemy_1.tscn")
const enemy_pusher = preload("res://scenes/enemy_missile.tscn")

@onready var spawning_circles = $Sprite2D
@onready var spawning_hunter = $Sprite2D2

var amount_spawned = 0
var max_can_spawn = 100
var spawner_active = false	
var particles_on : bool = false
var pusher_spawned : bool = false
var which_enemy

# notes: need proper differentiation between enemy types for effect_particles

func add_new_enemy(which_enemy = 5):
	if spawner_active and amount_spawned < max_can_spawn:
		if $"/root/Global".dev_enemies_on:
			if which_enemy < 5.0:
				var enemy_instance = enemy_basic.instantiate()
				enemy_instance.scale.x = 0.2
				enemy_instance.scale.y = 0.2
				add_child(enemy_instance)
				amount_spawned += 1
				global.swarmers_active += 1
				$Timer.wait_time = (7 - Global.global_difficulty) # default global difficulty is 1
			else:
				var enemy_instance = enemy_pusher.instantiate()
				add_child(enemy_instance)
				amount_spawned += 1	
				pusher_spawned = true
				next_pusher_possible_timer.start()
				$Timer.wait_time = (17 - Global.global_difficulty) # default global difficulty is 1
	$Timer.start()
				

func _on_timer_timeout():
	which_enemy = Global.random_float_number(1.0, 10.0)
	embiggen()
	spawn_circles_timer.start()
	

func _on_visible_on_screen_notifier_2d_screen_entered():
	spawner_active = true
	_on_timer_timeout()


func _on_visible_on_screen_notifier_2d_screen_exited():
	spawner_active = false


func _on_next_pusher_possible_timer_timeout():
	pusher_spawned = false
	# can spawn pusher again (if spawnpoint active)
	
func embiggen():
	var current_scale = spawning_circles.scale.x
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	# will only be expanding in size with each speed/power increase
	var target_animation = spawning_circles if which_enemy <= 5 else spawning_hunter
	tween.tween_property(
		target_animation, 
		"scale",
		Vector2(current_scale + 0.35, current_scale + 0.35),
		0.5   # Duration in seconds
		)
	tween.tween_property(
		target_animation, 
		"scale",
		Vector2(current_scale, current_scale),
		0.01   # Duration in seconds
		)
	tween.set_loops(3)	


func _on_spawn_circles_timer_timeout():
	add_new_enemy()
