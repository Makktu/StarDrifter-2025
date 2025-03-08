extends StaticBody2D

@onready var the_player = get_tree().get_nodes_in_group("player")[0]
@onready var global = $/root/Global
@onready var shield_barriers = $ShieldBarriers
@onready var shield_barriers_2 = $ShieldBarriers2
@onready var collision_shape_main = $CollisionShape_main
@onready var barrier_area = $barrier_area
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var on_particles = $CPUParticles2D
@onready var weapon_collisions = $barrier_area/CollisionShape2D
@onready var wider_collision_area = $wider_collision_area
@onready var barrier_particles_1 = $ShieldBarriers/CPUParticles2D
@onready var barrier_particles_2 = $ShieldBarriers2/CPUParticles2D

var barrier_visible = false
var barrier_active = true
var rotation_speed = 0.05
var player_taking_area_damage = false

func _process(delta):
	if player_taking_area_damage:
		global.player_energy -= 0.05
	if global.barrier_energy and barrier_visible:
		shield_barriers.rotation += rotation_speed
		shield_barriers_2.rotation += rotation_speed
		if !barrier_active:
			barrier_active = true
			on_particles.emitting = true
			barrier_particles_1.emitting = true
			barrier_particles_2.emitting = true
			weapon_collisions.disabled = false
		#shield_barriers.scale.x += rotation_speed
		#shield_barriers_2.rotation -= rotation_speed
	if !global.barrier_energy and barrier_active:
		on_particles.emitting = false
		barrier_particles_1.emitting = false
		barrier_particles_2.emitting = false
		weapon_collisions.disabled = true
		wider_collision_area.monitoring = false
		barrier_active = false		
		collision_shape_main.disabled = true
		barrier_area.monitoring = false
		barrier_area.monitorable = false
		timer.start()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_particles.emitting = true
	barrier_particles_1.emitting = true
	barrier_particles_2.emitting = true
	barrier_visible = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_particles.emitting = false
	barrier_particles_1.emitting = false
	barrier_particles_2.emitting = false
	barrier_visible = false

func _on_timer_timeout():
	animation_player.stop()
	collision_shape_main.disabled = false
	barrier_area.monitoring = true
	barrier_area.monitorable = true
	barrier_active = true


func _on_wider_collision_area_area_entered(area: Area2D) -> void:
	if area.name == "player_enemy_collision":
		print("Player entered barrier area")
		player_taking_area_damage = true


func _on_wider_collision_area_area_exited(area: Area2D) -> void:
	if area.name == "player_enemy_collision":
		print("Player left barrier area")
		player_taking_area_damage = false
