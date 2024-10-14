extends Node

@onready var sfx_manager = $sfx_manager
@onready var bgm_manager = $BGMusicManager
# ========================================================================================
# ======= DEVELOPER MENU OPTIONS VARIABLES ===============================================
var game_paused := false
var dev_damage_on := true # start with damage to player craft and energy penalties ON
var dev_enemies_on := true # start with enemies present in world
var player_bullets_can_be_fired := 3 # start able to fire 1 bullet
var dev_screenshake_on = true
# all variables controllable from dev pause menu, in hud scene
# ========================================================================================
# ========================================================================================
var player_energy := 100
var global_music_on := true
var alarm_triggered := false

# smartbomb variables
var equippables = {
	"smartbomb":"false",
}
var smart_bomb_active = false
var smart_bomb_equipped = false
# this will be a pickup; game is pickup-based

var player_energy_replenish_amount = 0.01 # can dynamically change
# monitor and control how many basic enemies
# exist in game world – for performance and gameplay
var enemy_basic_in_world = 0 

var player_damage = false
var player_amount_damaged = 0

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
	# TODO: need to fade it down
	bgm_manager.special_interrupt(on_or_off)

func damage_player(distance_from_player):#
	print('💥', distance_from_player)
	if !dev_damage_on:
		return
	player_damage = true
	player_amount_damaged = distance_from_player / 2
	
func taking_damage():
	return 1
