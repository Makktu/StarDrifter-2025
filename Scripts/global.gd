extends Node

var all_music:Array[String]

var current_track = 0
var maximum_track
var times_played = 0

@onready var main_audio_player = $AudioStreamPlayer

func _ready():
	for filePath in DirAccess.get_files_at("res://assets/music/bg_music/"):
		if filePath.get_extension() != "import":
			print(filePath)
			all_music.append("res://assets/music/bg_music/" + filePath)
	print(all_music)
	maximum_track = all_music.size() - 1



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func trigger_one():
	print (all_music[current_track])
	main_audio_player.volume_db = -50
	main_audio_player.stream = load(all_music[current_track])
	main_audio_player.play()
	if times_played == 0:
		if current_track < maximum_track:
			current_track += 1
		else:
			current_track = 0
	raise_volume()
	
func raise_volume():
	for n in 50:
		if main_audio_player.volume_db < 0:
			main_audio_player.volume_db += 1
		await get_tree().create_timer(0.5).timeout
