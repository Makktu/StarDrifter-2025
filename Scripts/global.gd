extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func trigger_one():
	$AudioStreamPlayer.play()
	raise_volume()
	
func raise_volume():
	for n in 100:
		$AudioStreamPlayer.volume_db += 0.5
		await get_tree().create_timer(0.5).timeout
