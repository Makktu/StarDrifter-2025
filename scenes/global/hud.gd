extends CanvasLayer

#@onready var energy_bar = $Control/EnergyBar

var warning_showing = false
var warning_times = 0

var basic_damage = 10

var energy_is_low = false

# Called when the node enters the scene tree for the first time.
func _ready():
	%VelocityBar.value = 0
	%EnergyBar.value = 100
	

func show_warning():
	warning_showing = true
	$warning.visible = true
	$WarningTimer.start()
	

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

func _on_warning_timer_timeout():
	warning_times += 1
	if warning_times <= 6:
		$WarningTimer.start()
		if $warning.visible:
			$warning.visible = false
		else:
			$warning.visible = true
	else:
		$warning.visible = false
		return


func _on_player_energy_change(energy):
	%EnergyBar.value = energy
	if energy <= 15 and !energy_is_low:
		energy_is_low = true
		%LowEnergy.play("low_energy")
	if energy > 15 and energy_is_low:
		energy_is_low = false
		%LowEnergy.play("RESET")


func _on_pause_button_pressed():
	if $"/root/Global".game_paused == false:
		$"/root/Global".game_paused = true
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
	else:
		$"/root/Global".toggle_bgm('on')
		$"/root/Global".global_music_on = true


func _on_damage_pressed():
	pass # Replace with function body.


func _on_enemies_pressed():
	pass # Replace with function body.


func _on_bullets_pressed():
	pass # Replace with function body.
