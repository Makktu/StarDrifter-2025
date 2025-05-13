extends Node2D

# "a single pickup to rule them all"
# replacing the multiple pickup scenes
# player can only have 1 pickup active at any one time
# new pickups cancel previous pickups if picked up within time limit (30 secs)
# a harvested pickup point will only spawn a new pickup 30 seconds later


@onready var all_pickups = {
	"speed": $pickup_node/speed,
	"shield": $pickup_node/shield,
	"energy": $pickup_node/energy,
	"three_bullets": $pickup_node/three_bullets
}
@onready var the_player = get_tree().get_nodes_in_group("player")[0]
@onready var particles = $CPUParticles2D
@onready var animation_player = $AnimationPlayer
@onready var spawn_timer = $spawn_timer
@onready var appearance_timer = $appearance_timer

var pickup_types : Array = ["speed", "shield", "energy", "three_bullets"]
var current_pickup : String = ""


func _ready():
	pick_pickup_type()


func pick_pickup_type():
	current_pickup = pickup_types[randi_range(0, (len(pickup_types) - 1))]
	#current_pickup = "shield" # for testing purposes
	hide_or_show_pickups("show")


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		the_player.picked_up(current_pickup) # initiate all changes in player node
		#animation_player.play("fade_away")
		#await get_tree().create_timer(1.5).timeout
		hide_or_show_pickups("hide")


func hide_or_show_pickups(hide_or_show = "show"):
	# Hide all pickups first
	for pickup in all_pickups.values():
		pickup.visible = false
		
	if hide_or_show != "hide":
		# Show only the current pickup
		all_pickups[current_pickup].visible = true
	
	if hide_or_show == "hide":
		spawn_timer.wait_time = randi_range(5, 15)
		print(">>>>", spawn_timer.wait_time)
		particles.emitting = false
		spawn_timer.start()
	

func _on_visible_on_screen_enabler_2d_screen_entered():
	if the_player.pickup_active:
		# what?
		pass
	particles.emitting = true
	#animation_player.play("waiting")


func _on_visible_on_screen_enabler_2d_screen_exited():
	particles.emitting = false
	#animation_player.play("waiting")


func _on_spawn_timer_timeout():
	# start the cycle again
	# restore particles for 5 seconds before pickup appearance
	particles.visible = true
	particles.emitting = true
	appearance_timer.start()


func _on_appearance_timer_timeout():
	pick_pickup_type()
