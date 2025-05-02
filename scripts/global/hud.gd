extends CanvasLayer

var warning_showing = false
var warning_times = 0
var basic_damage = 10
var energy_is_low = true
@onready var warning_sign = $warning

# Called when the node enters the scene tree for the first time.
#func _ready():
	#show_warning()
	

func show_warning(type = "default", critical_state = 1):
	# A slowly pulsing warning in an alien script when player energy is 20% of max
	# A faster pulsing warning at 10% of max
	# A final critical flashing warning at 5% (one more hit from anything is Game Over)
	if critical_state == 0:
		warning_showing = false
		warning_sign.visible = false
		return
	warning_showing = true
	#var tween = create_tween().set_loops()
	#tween.tween_property(warning_sign, "modulate:a", 0.0, critical_state / 2).set_trans(Tween.TRANS_SINE)
	#tween.tween_property(warning_sign, "modulate:a", 1.0, critical_state / 2).set_trans(Tween.TRANS_SINE)
	warning_sign.visible = true
	
		

func show_velocity(x, y, delta):
	var combined_velocity = x * y * delta
	if combined_velocity < 0:
		combined_velocity = -combined_velocity
	$velocity/Label.text = str(snapped(combined_velocity, 0.1))
	%VelocityBar.value = (combined_velocity / 2) * 2
	$acceleration_animation.play("accel_glow")


func thrust_pressed():
	$Control/EnergyBar/CPUParticles2D.emitting = true
	
	
func thrust_released():
	$Control/EnergyBar/CPUParticles2D.emitting = false

		
			
func show_energy(energy):
	$energy/Label.text = str(energy)


func _on_pause_button_pressed(is_game_over = false):
	if is_game_over:
		$"/root/Global".game_paused = false # will cause game to pause at next step
	if $"/root/Global".game_paused == false:
		$"/root/Global".game_paused = true
		# put game over menu in here and link to various
		if is_game_over:
			print("World to go monochrome here!")
			print('GAME OVER')
		$developer_pause.visible = true
		get_tree().paused = true
	else:
		$"/root/Global".game_paused = false
		$developer_pause.visible = false
		get_tree().paused = false

func _on_resume_pressed():
	_on_pause_button_pressed()


func _on_music_pressed():
	if $"/root/Global".global_music_on:
		$"/root/Global".toggle_bgm('off')
		$"/root/Global".global_music_on = false
		$developer_pause/Music.text = 'Music is OFF'
	else:
		$"/root/Global".toggle_bgm('on')
		$"/root/Global".global_music_on = true
		$developer_pause/Music.text = 'Music is ON'


func _on_damage_pressed():
	if $"/root/Global".dev_damage_on:
		$"/root/Global".dev_damage_on = false
		$developer_pause/Damage.text = 'Damage is OFF'
	else:
		$"/root/Global".dev_damage_on = true
		$developer_pause/Damage.text = 'Damage is ON'
		


func _on_enemies_pressed():
	if $"/root/Global".dev_enemies_on:
		$"/root/Global".dev_enemies_on = false
		$developer_pause/Enemies.text = 'Enemies are OFF'
	else:
		$"/root/Global".dev_enemies_on = true
		$developer_pause/Enemies.text = 'Enemies are ON'


func _on_bullets_pressed():
	if $"/root/Global".player_bullets_can_be_fired < 3:
		$"/root/Global".player_bullets_can_be_fired += 1
	else:
		$"/root/Global".player_bullets_can_be_fired = 1
	$developer_pause/Bullets.text = 'Firing Bullets: ' + str($"/root/Global".player_bullets_can_be_fired)


func _on_screenshake_pressed():
	if $"/root/Global".dev_screenshake_on:
		$"/root/Global".dev_screenshake_on = false
		$developer_pause/Screenshake.text = 'Screen Shake is OFF'
	else:
		$"/root/Global".dev_screenshake_on = true
		$developer_pause/Screenshake.text = 'Screen Shake is ON'


func _on_continue_pressed():
	$"/root/Global".player_energy = 100
	$"/root/Global".game_paused = false
	$developer_pause.visible = false
	get_tree().paused = false
	
func smartbomb_message_toggle(on_or_off = false):
	if on_or_off:
		$SmartBomb.visible = true
	else:
		$SmartBomb.visible = false
	


func _on_regular_mode_pressed():
	if Global.play_mode == 1:
		Global.play_mode = 2
		$"developer_pause/Regular Mode".text = "Arcade Mode"
	else:
		Global.play_mode = 1
		$"developer_pause/Regular Mode".text = "Regular Mode"
