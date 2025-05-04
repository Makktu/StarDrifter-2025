extends Node2D

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_regular_mode_pressed():
	if Global.play_mode == 0:
		Global.play_mode = 1
		$"Regular Mode".text = "Arcade Mode"
		Global.universal_speed = 750.0
	else:
		Global.play_mode = 0
		$"Regular Mode".text = "Regular Mode"
		Global.universal_speed = 100.0
	print(Global.universal_speed)
