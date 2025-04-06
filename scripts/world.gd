extends Node2D

@onready var player = $Player

#func _ready():
	#setup_crt_effect()

func _on_zoom_out_1_body_entered(body):
	print(body.name)
	if body.name != 'Player':
		return
	if Global.alarm_triggered:
		return
	Global.alarm_triggered = true
	player.camera_special('zoomout')
	Global.toggle_bgm('off')
	Global.sound_alarm()
	

func setup_crt_effect():
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100  # Put it on top of everything
	add_child(canvas_layer)
	# Remove any existing CRT effect
	if has_node("CRTEffect"):
		get_node("CRTEffect").queue_free()
	
	# Create new ColorRect
	var color_rect = ColorRect.new()
	color_rect.name = "CRTEffect"
	
	# Make sure it covers the entire viewport
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Make it ignore mouse input
	
	# Create shader material
	var shader_material = ShaderMaterial.new()
	var shader = load("res://scenes/world.gdshader")  # Adjust path as needed

	if shader == null:
		print("Failed to load shader!")
		return
		
	shader_material.shader = shader
	color_rect.material = shader_material

	# Add to scene as child of root
	add_child(color_rect)
	move_child(color_rect, get_child_count() - 1)
	canvas_layer.add_child(color_rect)

	# Debug prints
	print("CRT Effect setup complete")
	print("ColorRect size: ", color_rect.size)
	print("ColorRect material: ", color_rect.material)
	print("Shader assigned: ", color_rect.material.shader if color_rect.material else "No shader")


func _on_first_boss_body_entered(body):
	print(body.name)
	if body.name == "player":
		print("The gates are closed...")
		player.camera_letterbox_effect()


func _on_first_boss_area_entered(area):
	player.camera_letterbox_effect()
