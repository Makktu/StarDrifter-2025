extends Node2D

@onready var portal_emitter = $CPUParticles2D


func _on_visible_on_screen_notifier_2d_screen_entered():
	# activate particles when portal is on or near screen
	portal_emitter.emitting = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	# deactivate particles when portal is off-screen
	portal_emitter.emitting = false
