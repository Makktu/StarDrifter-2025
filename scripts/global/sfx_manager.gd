extends Node2D

@onready var alarms = $alarms
@onready var threats = $threats

var times_alarm_played = 0
var alarm_duration := 3
var alarm_in_progress = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func sound_alarm():
	# if alarm is already sounding, don't sound another	
	alarm_in_progress = true
	if alarm_duration == 0:
		alarm_duration = 3
		alarm_in_progress = false
		$"..".toggle_bgm('on')
		$"..".alarm_triggered = false		
		return
	# stop any background music playing
	threats.play()
	alarm_duration -= 1

func _on_alarms_finished():
	sound_alarm()


func _on_threats_finished():
	sound_alarm()
