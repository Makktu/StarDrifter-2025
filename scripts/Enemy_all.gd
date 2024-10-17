extends Node

class_name Enemy_all

# Declare member variables
var enemy_name: String
var enemy_health: int

# Constructor to initialize the class
func _init(_enemy_name: String, _enemy_health: int):
	enemy_name = _enemy_name
	enemy_health = _enemy_health
