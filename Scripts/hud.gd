extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func show_warning():
	if $warning.visible:
		return
	$warning.visible = true
	$WarningTimer.start()


func _on_warning_timer_timeout():
	$warning.visible = false
