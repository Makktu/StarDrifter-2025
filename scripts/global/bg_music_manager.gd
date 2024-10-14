extends Node2D

@onready var main_audio_player = $AudioStreamPlayer

var all_music:Array[String]
var current_track := 0
var maximum_track := 0
var times_played := 0

func _ready():
	# load all music in named folder
	for filePath in DirAccess.get_files_at("res://assets/music/bg_music/"):
		if filePath.get_extension() != "import":
			print(filePath)
			all_music.append("res://assets/music/bg_music/" + filePath)
	print(all_music)
	maximum_track = all_music.size() - 1

func start_bg_music():
	$bg_music_timer.start()
	

func play_next_track():
	main_audio_player.stream = load(all_music[current_track])
	main_audio_player.play()
	if current_track < maximum_track:
		current_track += 1
	else:
		current_track = 0
		
func play_shorts():
	pass
	
func raise_volume():
	for n in 50:
		if main_audio_player.volume_db < 0:
			main_audio_player.volume_db += 1
		await get_tree().create_timer(0.5).timeout

# +++++++++++++++++++++++++++++++++++++++
# The background music finishes, and a timer starts
# to stop another track being triggered before
# 1 minute has passed. Spaces out the tracks
func _on_audio_stream_player_finished():
	$bg_music_timer.start()
	
func _on_bg_music_timer_timeout():
	play_next_track()
# +++++++++++++++++++++++++++++++++++++++

func special_interrupt(on_or_off = 'on'):
	# to be called whenever the player triggers an sfx-level alarm or mood music
	if on_or_off == 'off':
		main_audio_player.stop()
	else:
		start_bg_music()
