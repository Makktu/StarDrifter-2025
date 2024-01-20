extends Node2D

@onready var player_acceleration = 40 #30
@onready var player_max_speed = 55
@onready var player_gravity = 0 #0 FOR FULL WEIGHTLESSNESS
@onready var player_rotation_speed = 3 #6

var input_vector : Vector2

func _physics_process(delta):

	input_vector.x = Input.get_action_strength("Thrust")
			
