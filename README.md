# SpaceLander2D (2024)

A 2D game for mobile. Developed on the Godot 4 engine. Distantly inspired by the 1970s arcade classic LUNAR LANDER.

Fly your spaceship through a hostile environment to the landing pad.

The spaceship is equipped with limited Energy and will have to constantly resupply en route.

Pickups come in the form of enhanced weaponry and other items.

___

# To test the project

In Godot 4, navigate in the project folder to 'project.godot' and open it.

___

# Controls (Desktop only – Mobile touchscreen: TBD)

⬆️  – Thrust

⬅️  – Rotate left

➡️  – Rotate right

SPACEBAR – Fire


___

# Enemies

All enemies emerge from portals at certain locations around the map 

### SPACEMINE

![spacemine_enemy](https://github.com/Makktu/SpaceLander2D-2024-/blob/main/scenes/enemies/enemy_assets/enemy1_mine1.png)

- a slow, floating, rotating mine that homes in on the player
- rotates progressively faster as it nears the player; will abruptly speed up at the last and explode on contact
- causes -10 Energy Loss to player caught in its explosion
- **does not path-find**; will tend to get snagged on environment scenery and then all emerge at once
- on their own and in small groups can be easily evaded/destroyed, but can accumulate in large groups that can overwhelm a careless player
- lifespan of 40 seconds off-screen.
- maximum of 100 active on the map at any one time; as one expires or is destroyed, another spawns somewhere (randomly)

___

# proposed track listing:
	
	White Bat Audio (Karl Casey)
	
	1. Elysium

# Project revival October 2024

Here we go yet again.

### Tues 15 Oct 2024

Re-organised the project to make it more manageable.

Removed the HUD features (which were mostly cosmetic).

Shrunk the environment down to something more suitable for mobile screens.

Added bullet trail.

Lots of things up in the air and provisional.

### Thur 19 December 2024

And we're back! Limping progress while my memory returns of some of the most basic elements of Godot. It's only been a couple of months, but that was a fleeting visit even then. Probably a year, in effect, since I was immersed in this project and Godot as a whole.

Currently stuck on adding a new enemy to the game that is meant to phase in and out of visibility.

Working on it. Using Tweens instead of animation player, etc
