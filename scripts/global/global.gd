extends Node

@onready var sfx_manager = $sfx_manager
@onready var bgm_manager = $BGMusicManager
# ========================================================================================
# ======= DEVELOPER MENU OPTIONS VARIABLES ===============================================
var game_paused : bool = false
var dev_damage_on : bool = true # start each play session with damage to player craft and energy penalties ON
var dev_enemies_on : bool = true # start with enemies present in world
var player_bullets_can_be_fired : int = 1 # start able to fire 1 bullet
var dev_screenshake_on : bool = true
# all variables controllable from dev pause menu, in hud scene
# ========================================================================================
# ========================================================================================
var player_energy : float = 100.0
var global_music_on : bool = false # debug setting
var alarm_triggered : bool = false

# smartbomb variables
#var equippables = {
	#"smartbomb":"false",
#}
#var smart_bomb_active = false
#var smart_bomb_equipped = false
# this will be a pickup; game is pickup-based

var player_energy_replenish_amount : float = 0.005 # amount player energy naturally replenishes by per frame - can dynamically change
# monitor and control how many basic enemies
# exist in game world – for performance and gameplay
var enemy_basic_in_world : int = 0 

var player_damage : bool = false
var player_amount_damaged : int = 0


func _ready():
	# start bgm music if bgm_music ON
	print("STARTING DAMAGE:", player_energy)
	if global_music_on:
		bgm_manager.start_bg_music()
		

func random_float_number(lower_value = 0, upper_value = 1): # returns random val between these parameters
	var random_generator = RandomNumberGenerator.new()
	random_generator.randomize()
	var random_value = random_generator.randf_range(lower_value, upper_value)
	return random_value
				

func sound_alarm():
	sfx_manager.sound_alarm()
	

func damage_player(distance_from_player):#
	print('💥', distance_from_player)
	if !dev_damage_on:
		return
	player_damage = true
	player_amount_damaged = distance_from_player / 2
	

func taking_damage(hit = 1):
	player_energy -= hit
	print("DAMAGE TAKEN:", hit)
	print("ENERGY:", player_energy)
		

func player_energy_replenish(amount = player_energy_replenish_amount):
	# top up the player's energy by a fixed amount
	# default is the global value
	# function can be passed value for pickups etc
	if player_energy < 100: # no action if energy is full
		player_energy += amount
