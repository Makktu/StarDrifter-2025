extends Node

var global_music_on = false

func _ready():
	if global_music_on:
		$BGMusicManager.start_bg_music()
	
	

