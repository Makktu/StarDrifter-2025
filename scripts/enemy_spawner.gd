extends Node2D

@onready var global = $/root/Global

const enemy_basic = preload("res://scenes/enemy_1.tscn")
var amount_spawned = 0
var spawner_active = false	

func add_new_enemy():
	if spawner_active:
		if $"/root/Global".dev_enemies_on:
			var enemy_instance = enemy_basic.instantiate()
			add_child(enemy_instance)
			amount_spawned += 1
		$Timer.start()

func _on_timer_timeout():
	if $"/root/Global".enemy_basic_in_world < global.max_enemies:
		$"/root/Global".enemy_basic_in_world += 1
		add_new_enemy()
	else:
		$Timer.start()

func _on_visible_on_screen_notifier_2d_screen_entered():
	spawner_active = true
	$Timer.start()

func _on_visible_on_screen_notifier_2d_screen_exited():
	spawner_active = false
