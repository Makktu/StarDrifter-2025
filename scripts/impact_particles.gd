extends Node2D

@onready var collision_particles = $collision_particles

func _ready():
	collision_particles.emitting = true
