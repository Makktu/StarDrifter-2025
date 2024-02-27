extends Node

@onready var sfx_manager = $sfx_manager
@onready var bgm_manager = $BGMusicManager

var global_music_on := true
var alarm_triggered := false
var smart_bomb_active = false

# monitor and control how many basic enemies
# exist in game world – for performance and gameplay
var enemy_basic_in_world = 0 

func _ready():
	if global_music_on:
		bgm_manager.start_bg_music()
		
func random_float_number(lower_value, upper_value):
	var random_generator = RandomNumberGenerator.new()
	random_generator.randomize()
	var random_value = random_generator.randf_range(lower_value, upper_value)
	return random_value
				
func sound_alarm():
	sfx_manager.sound_alarm()
	
func toggle_bgm(on_or_off):
	# called when local sfx and threat-type stingers are triggered
	# and background music needs to be stopped if playing
	bgm_manager.special_interrupt(on_or_off)
