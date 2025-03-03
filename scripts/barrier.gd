extends StaticBody2D

@onready var the_player = get_tree().get_nodes_in_group("player")[0]
@onready var global = $/root/Global
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shield_barriers = $ShieldBarriers
@onready var shield_barriers_2 = $ShieldBarriers2
@onready var collision_shape_main = $CollisionShape_main
@onready var barrier_area = $barrier_area
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var on_particles = $CPUParticles2D
@onready var weapon_collisions = $barrier_area/CollisionShape2D
@onready var barrier_plain = $Sprite2D

var barrier_visible = false
var barrier_active = true
var rotation_speed = 0.1
var barrier_hp = 100
var player_taking_area_damage = false

func _process(delta):
	if player_taking_area_damage:
		global.player_energy -= 0.05
	if global.barrier_energy and barrier_visible:
		if !barrier_active:
			barrier_active = true
			on_particles.emitting = true
			weapon_collisions.disabled = false
		shield_barriers.rotation += rotation_speed
		shield_barriers_2.rotation -= rotation_speed
	if !global.barrier_energy and barrier_active:
		on_particles.emitting = false
		weapon_collisions.disabled = true
		barrier_active = false		
		animated_sprite.visible = false
		collision_shape_main.disabled = true
		barrier_area.monitoring = false
		barrier_area.monitorable = false
		timer.start()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animation_player.play("active_barrier")
	animated_sprite.play()
	on_particles.emitting = true
	barrier_visible = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	animated_sprite.stop()
	animation_player.stop()
	barrier_visible = false


func _on_area_2d_area_entered(area):
	barrier_hp -= 10


func _on_timer_timeout():
	barrier_hp = 100
	animation_player.stop()
	animated_sprite.visible = true
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
