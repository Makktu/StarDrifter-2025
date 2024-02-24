extends Node2D

const enemy_basic = preload("res://scenes/enemies/enemy_1.tscn")

var amount_spawned = 0

func _ready():
	$Timer.start()

func add_new_enemy():
	var enemy_instance = enemy_basic.instantiate()
	add_child(enemy_instance)
	amount_spawned += 1

func _on_timer_timeout():
	if amount_spawned < 20:
		add_new_enemy()
