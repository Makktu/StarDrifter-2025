extends Node2D

@onready var player = $Player
@onready var world_environment = $WorldEnvironment
@onready var health_tween = create_tween()

var changing_glow = false
	
func process():
	if Global.player_energy <= 20 and not changing_glow:
		changing_glow = true
		update_environment_effects()
		
func update_environment_effects():
	print("GOT TO FUNCTION!")
	var env = world_environment.environment.duplicate()
	# Calculate target values based on health (0-100)
	var health_ratio = Global.player_energy / 100.0
	
	# Configure tween
	health_tween.kill()  # Stop any previous tween
	health_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# Animate properties (with example values)
	health_tween.tween_property(env, "adjustment_saturation",
	clamp(health_ratio, 0.1, 1.0),  # Never go full grayscale
		0.5  # Duration in seconds
		)
		
	# Example: Add more effects
	health_tween.parallel().tween_property(env, "adjustment_contrast",
	clamp(health_ratio * 1.5, 0.8, 1.5),
		0.5
		)
		
	health_tween.parallel().tween_property(env, "glow_intensity",
	clamp(health_ratio * 2.0, 0.2, 1.5),
	0.5
	)
	
	# Apply the modified environment when tween starts
	health_tween.tween_callback(func(): world_environment.environment = env)
	

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
