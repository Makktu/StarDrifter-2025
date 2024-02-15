extends Node

@onready var alarms = $alarms
var global_music_on = false
var times_alarm_played = 0
var alarm_duration := 3
var alarm_in_progress := false

func _ready():
	if global_music_on:
		$BGMusicManager.start_bg_music()
	
func sound_alarm():
	if !alarm_in_progress:
		alarm_in_progress = true
	if alarm_duration == 0:
		alarm_duration = 3
		alarm_in_progress = false
		return
	alarms.play()
	alarm_duration -= 1


func _on_alarms_finished():
	sound_alarm()
