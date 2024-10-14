extends Node2D

const enemy_basic = preload("res://scenes/enemy_1.tscn")

var amount_spawned = 0

func _ready():
	$Timer.start()

func add_new_enemy():
	if $"/root/Global".dev_enemies_on:
		var enemy_instance = enemy_basic.instantiate()
		add_child(enemy_instance)
		amount_spawned += 1
	$Timer.start()

func _on_timer_timeout():
	if $"/root/Global".enemy_basic_in_world < 100:
		$"/root/Global".enemy_basic_in_world += 1
		add_new_enemy()
	else:
		$Timer.start()
		
