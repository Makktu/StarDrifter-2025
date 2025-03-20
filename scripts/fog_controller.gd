extends Node2D

@onready var fade_timer = $FadeTimer
@onready var fog = $Sprite2D

var fade_out_time : int
var fade_status : String = "out" # should be next desired fade, opposite of starting state (fog is in)
var move_fog_x : float = 0.15
var move_fog_y : float = 0.15
var move_fog_counter : int = 0

func _ready():
	fade_timer.start()


func _process(delta):
	position.x += move_fog_x
	position.y += move_fog_y
	move_fog_counter += 1
	if move_fog_counter >= 300:
		move_fog_counter = 0
		move_fog_x = -move_fog_x
		move_fog_y = -move_fog_y


func _on_fade_timer_timeout():
	#create Tween object
	var target_alpha : float
	var tween = get_tree().create_tween()
	if fade_status == "out":
		target_alpha = 0.0
		fade_status = "in" # always switch to next desired state
	else:
		target_alpha = 1.0
		fade_status = "out"
	# Tween the alpha value to 0 or 256
	tween.tween_property(
		fog, 
		"modulate:a", 
		target_alpha,  # Target alpha
		20.0   # Duration in seconds
		).set_ease(Tween.EASE_IN_OUT)
	fade_timer.wait_time = random_number(22, 32)
	fade_timer.start()


#lots of random numbers required for future management of fog effects
func random_number(low = 20, high = 40):
	var random_number = randi_range(low, high)
	print("random number:", random_number)
	return random_number
