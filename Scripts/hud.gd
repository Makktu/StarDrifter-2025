extends CanvasLayer

var warning_showing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func show_warning():
	warning_showing = true
	$warning.visible = true
	$WarningTimer.start()
	

func show_velocity(x, y, delta):
	var combined_velocity = x * y * delta
	if combined_velocity < 0:
		combined_velocity = -combined_velocity
	$velocity/Label.text = str(snapped(combined_velocity, 0.1))
	
func show_energy(energy):
	$energy/Label.text = str(energy)

func _on_warning_timer_timeout():
	$WarningTimer.start()
	if $warning.visible:
		$warning.visible = false
	else:
		$warning.visible = true
