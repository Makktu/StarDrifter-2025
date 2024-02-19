extends Node

@onready var sfx_manager = $sfx_manager
@onready var bgm_manager = $BGMusicManager

var global_music_on := true

func _ready():
	if global_music_on:
		bgm_manager.start_bg_music()
				
func sound_alarm():
	sfx_manager.sound_alarm()
	
