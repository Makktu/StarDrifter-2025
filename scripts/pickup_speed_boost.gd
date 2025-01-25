extends Node2D

@onready var the_player = get_tree().get_nodes_in_group("player")[0]
@onready var animation_player = $AnimationPlayer
@onready var particles = $CPUParticles2D

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		the_player.picked_up("energy") # initiate all changes in player node
		animation_player.play("fade_away")
		await get_tree().create_timer(1.5).timeout
		queue_free()

func _on_visible_on_screen_enabler_2d_screen_entered():
	particles.emitting = true
	animation_player.play("waiting")


func _on_visible_on_screen_enabler_2d_screen_exited():
	particles.emitting = false
	animation_player.stop()
