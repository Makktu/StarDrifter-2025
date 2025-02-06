extends Node2D

@onready var global = $/root/Global
@onready var fade_timer = $FadeTimer
@onready var fog = $Sprite2D


func _ready():
	fade_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += 0.5


func _on_fade_timer_timeout():
	 #create Tween object
	var tween = get_tree().create_tween()
	# Tween the alpha value back to 0
	tween.tween_property(
		fog, 
		"modulate:a", 
		0.0,  # Target alpha
		10.0   # Duration in seconds
		).set_ease(Tween.EASE_IN_OUT)
