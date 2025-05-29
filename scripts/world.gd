extends Node2D

@onready var player = $Player
@onready var world_environment = $WorldEnvironment
@onready var health_tween = create_tween()
var up_glow : bool = true
var down_glow : bool = false
var glow_is_changing : bool = false

# ------------------------------------------------

func _process(delta):
	# handling the world glow health effect entirely in its own node
	if Global.player_energy <= 20 and up_glow and not glow_is_changing:
		up_glow = false
		down_glow = true
		glow_is_changing = true # ensure current change can complete if cancelled mid-change
		update_environment(0)
	if Global.player_energy > 20 and down_glow and not glow_is_changing:
		up_glow = true
		down_glow = false
		glow_is_changing = true
		update_environment(1)	
			

func update_environment(health_ratio: float = 1.0):
	# Work directly with the actual environment, don't duplicate
	var env = world_environment.environment
	
	# Calculate target values based on health ratio
	var target_saturation = clamp(health_ratio, 0.3, 1.0)
	#var target_contrast = clamp(health_ratio * 1.5, 0.8, 1.5)
	var target_glow_intensity = clamp(health_ratio * 2.0, 0.4, 1.5)
	
	# Configure tween
	health_tween.kill()
	health_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Tween the properties directly on the active environment
	health_tween.tween_property(env, "adjustment_saturation", target_saturation, 10.0)
	#health_tween.parallel().tween_property(env, "adjustment_contrast", target_contrast, 8.0)
	health_tween.parallel().tween_property(env, "glow_intensity", target_glow_intensity, 10.0)
	
	health_tween.tween_callback(func():
		glow_is_changing = false
		)

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
