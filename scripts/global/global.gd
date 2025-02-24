extends Node

#@onready var debug_msg_timer = $debug_msg_timer
@onready var sfx_manager = $sfx_manager
@onready var bgm_manager = $BGMusicManager
# ========================================================================================
# ======= DEVELOPER MENU OPTIONS VARIABLES ===============================================
var game_paused : bool = false
var dev_damage_on : bool = true # start each play session with damage to player craft and energy penalties ON
var dev_enemies_on : bool = false # start with enemies present in world
var dev_screenshake_on : bool = true
# all variables controllable from dev pause menu, in hud scene
# ========================================================================================
# ========================================================================================

var player_energy : float = 100.0
var global_music_on : bool = true # debug setting
var alarm_triggered : bool = false

var speed_pickup_active: bool = false

# max number of enemies allowed on-screen or in vicinity at one time
var max_enemies = 300

# amount player energy naturally replenishes by per frame - can dynamically change
var player_energy_replenish_amount : float = 0.005

# monitor and control how many basic enemies
# exist in game world – for performance and gameplay
var swarmers_active : int = 0 

var player_damage : bool = false
var player_amount_damaged : int = 0

var shield_active : bool = false

var base_damage : float = 1.0 # the basis for calculating damage inflicted by all events

var global_difficulty : int = 1 # if global difficulty needs a number... (nowhere near implemented)
# potentials for this: 1 - regular 2 - hard 3 - extreme

var barrier_energy : bool = true

func _ready():
	# start bgm music if bgm_music ON
	if global_music_on:
		bgm_manager.start_bg_music()
	#debug_msg_timer.start()
		

func random_float_number(lower_value = 0, upper_value = 1): # returns random val between these parameters
	var random_generator = RandomNumberGenerator.new()
	random_generator.randomize()
	var random_value = random_generator.randf_range(lower_value, upper_value)
	return random_value
				

func sound_alarm():
	sfx_manager.sound_alarm()
	

func damage_player(distance_from_player):#
	if !dev_damage_on or shield_active:
		return
	player_damage = true
	player_amount_damaged = distance_from_player / 2
	

func taking_damage(hit = 1):
	if !shield_active:
		player_energy -= hit
		

func player_energy_replenish(amount = player_energy_replenish_amount):
	# top up the player's energy by a fixed amount
	# default is the global value
	# function can be passed value for pickups etc
	if player_energy < 100: # no action if energy is full
		player_energy += amount
