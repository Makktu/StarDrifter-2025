extends Node2D

@onready var global = $/root/Global
@onready var fade_timer = $FadeTimer
@onready var return_timer = $ReturnTimer
@onready var fog = $Sprite2D

var fade_out_time : int
var fade_status : String = "in"
var move_fog_x : float = 0.5
var move_fog_y : float = 0.25
var move_fog_speed_change_increment : float = 0.15

#func _ready():
	#fade_out_time = random_number(5, 10)
	#fade_timer.wait_time = fade_out_time
	#fade_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += move_fog_x
	position.y += move_fog_y
	if position.x >= 4240 or position.x <= -3220:
		move_fog_x = -move_fog_x
	if position.y >= 2070 or position.y <= -3100:
		move_fog_y = -move_fog_y
	# randomly change speed/direction of fog
	if random_number(1,100) > 50 and move_fog_x < 1.25 and move_fog_y < 1.25:
		move_fog_x += move_fog_speed_change_increment
		move_fog_y += move_fog_speed_change_increment
	if move_fog_y >= 1.25:
		move_fog_y = 0.25
	if move_fog_x >= 1.25:
		move_fog_x = 0.25


func _on_fade_timer_timeout():
	 #create Tween object
	var target_alpha : float
	var tween = get_tree().create_tween()
	if fade_status == "out":
		target_alpha = 16.0
		fade_status = "in"
	else:
		target_alpha = 0.0
		fade_status = "out"
	# Tween the alpha value to 0 or 256
	tween.tween_property(
		fog, 
		"modulate:a", 
		target_alpha,  # Target alpha
		10.0   # Duration in seconds
		).set_ease(Tween.EASE_IN_OUT)
	#fade_out_time = random_number(12, 15)
	#fade_timer.wait_time = fade_out_time
	#fade_timer.start()

		
func random_number(low = 1, high = 10): # lots of random numbers required for this
	var random_number = randi_range(low, high)
	return random_number
