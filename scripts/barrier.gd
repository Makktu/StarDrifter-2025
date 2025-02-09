extends Area2D

@onready var the_player = get_tree().get_nodes_in_group("player")[0]
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite.play()
	animation_player.play("throb")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	animated_sprite.stop()


func _on_body_entered(body: Node2D) -> void:
	print(body.name)
