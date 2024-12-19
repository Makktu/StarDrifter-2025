extends Node2D

var phased_out = true
var time_to_next_phase_in = 5 # time in seconds to next appearance on map
@onready var phase_timer = $PhaseTimer
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	phase_timer.wait_time = time_to_next_phase_in
	phase_timer.start()
	
func phase(phase_type = 0):
	animation_player.play("phase_in")
	

func _on_phase_timer_timeout():
	if phased_out:
		phase(1)
	else:
		phase(0)
