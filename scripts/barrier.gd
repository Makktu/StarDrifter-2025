extends StaticBody2D

@onready var the_player = get_tree().get_nodes_in_group("player")[0]

@onready var shield_barriers = $ShieldBarriers
@onready var shield_barriers_2 = $ShieldBarriers2
@onready var collision_shape_main = $CollisionShape_main
@onready var barrier_area = $barrier_area
@onready var weapon_collisions = $barrier_area/CollisionShape2D
@onready var wider_collision_area = $wider_collision_area
@onready var on_particles = $CPUParticles2D
@onready var barrier_particles_1 = $ShieldBarriers/CPUParticles2D
@onready var barrier_particles_2 = $ShieldBarriers2/CPUParticles2D

var barrier_visible : bool = false
var rotation_speed : int = 0.05
var player_taking_area_damage : bool = false
var barrier_active : bool = false


func _process(delta):
	# stop the barrier if energy disabled
	if Input.is_key_pressed(KEY_BACKSPACE):
		print(barrier_active, barrier_visible)
	if Global.barrier_energy and barrier_visible:
		shield_barriers.rotation += rotation_speed
		shield_barriers_2.rotation += rotation_speed
	if !Global.barrier_energy and barrier_active:
		barrier_active = false
		player_taking_area_damage = false
		on_particles.emitting = false
		barrier_particles_1.emitting = false
		barrier_particles_2.emitting = false
		weapon_collisions.disabled = true
		wider_collision_area.monitoring = false
		collision_shape_main.disabled = true
		barrier_area.monitoring = false
		barrier_area.monitorable = false
		return
	if Global.barrier_energy and !barrier_active:
		restore_barrier()
	if player_taking_area_damage:
		Global.player_energy -= 0.05


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_particles.emitting = true
	barrier_particles_1.emitting = true
	barrier_particles_2.emitting = true
	barrier_visible = true
	barrier_active = true
	print("BARRIER ENTERED")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_particles.emitting = false
	barrier_particles_1.emitting = false
	barrier_particles_2.emitting = false
	barrier_visible = false
	barrier_active = false
	print("BARRIER EXITED")


func restore_barrier():
	barrier_visible = true
	barrier_active = true
	collision_shape_main.disabled = false
	wider_collision_area.monitoring = true
	weapon_collisions.disabled = false
	barrier_area.monitoring = true
	barrier_area.monitorable = true
	on_particles.emitting = true
	barrier_particles_1.emitting = true
	barrier_particles_2.emitting = true
	

func _on_wider_collision_area_area_entered(area: Area2D) -> void:
	if area.name == "player_enemy_collision":
		player_taking_area_damage = true


func _on_wider_collision_area_area_exited(area: Area2D) -> void:
	if area.name == "player_enemy_collision":
		player_taking_area_damage = false
