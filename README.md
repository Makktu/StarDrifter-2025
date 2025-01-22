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

### Tues 24 December 2024

Fixed the Phantom enemy's laser weapon. The laser was causing the game to crash because I was trying to reuse the same laser instance multiple times. Now creating a new instance each time it fires.

Also sorted out the laser beam length and collision detection. The beam now properly extends to 3000 pixels or until it hits something, and the phantom tracks the player properly when phased in.

Still more to do with this enemy type (e.g. laser appearance, timing, deadliness, and whether the phantom should move around), but the core mechanics are working now.

### Wed 25 December 2024

Adjusted Phantom behaviour. Added new sprite for it.

### Sun 29 December 2024

Officially changed project name to StarDrifter.

Next up: tidying the project. Pruning all the legacy code and nodes from previous layers of activity.

### Mon 30 December 2024

- Started the tidy-up.
- Removed some redundant code.
- Experimenting with faster player speed & bullets.
- Gone down to one bullet only for the player (remainder in pickup?).

### Tue 31 December 2024

Fixed problem with player bullets detecting collisions with player when fired. (Problem was a shared collision layer.)

Removed dynamic camera zoom for now, possibly for good.

Further tidying up of redundant code.

Smartbomb code only commented out for now in case the feature is kept.

### Wed 1 Jan 2025

Experimented with a few shaders for a CRT-like effect. Not promising.

### Thu 2 Jan 2025

Removed shaders for now (need a game first).

Starting work on player damage system for player. This means unpicking the several layers of previous damage systems.
Will inevitably just re-do it all, but seeing what can be salvaged for now.

### Fri 3 Jan 2025

More damage system work.
Collisions with environment will have a fixed penalty on the ship's energy value.
Starting energy: 100.
0 energy is Game Over.
The player's energy will replenish by some value - 0.01 - per frame. 
Pickups will be added to top up energy, or create a shield effect.
For now, just making basic collisions and background replenish consistent.
Lots of legacy code to remove. Simplifying everything.
Work in progress.

### Sat 4 Jan 2025

Finally pruned all the old code from global and player scripts.
Basic damage system now working and functions set up.

### Sun 5 Jan 2025

Working on Phantom enemy - behaviours and collision logic
This enemy if collided with will repel the player at 1.5x speed
It will phase out when damaged, recharge, and phase back in
Cannot be destroyed except with 3x bullets

### Mon 6 Jan 2025

Working on collisions again - a mess. Need closer detailed work.

### Tue 7 Jan 2025

The whole project is a mess. Collisions will need to be ripped up and started again.

Phantom behaviour also currently wonky.

Worked on both of these enough today and in total until now to see the mess.

A MESS.

### Wed 8 Jan 2025

Still struggling with Phantom behaviour. This is getting bogged down on ONE enemy type.

### Thu 9 Jan 2025

Gave in and used Area2D for collisions. Hack amateur stuff but it works.
Phantom is now 99% working, just the off-screen dormancy thing to resolve now.

### Fri 10 Jan 2025

Fixed problem with bullet collisions (layer/mask issue).

### Sat 11 Jan 2025

Started on décor for world environment. RKO/Tesla-style radio towers etc.

### Mon 13 Jan 2025

Adding effects and purpose for 'Energy Towers' - need to consider gameplay role

### Tue 14 Jan 2025

Scope of game now has 'Vampire Survivor' vibe.
I.e. lots of on-screen enemies and a basic upgrade/pickup system.
Started on this.
Will need careful balancing.

### Wed 15 Jan 2025

Expanded world back to 1.0 size, giving the player lots of room to move and drift around in.
Added enemies to a few locations.
Very positive feeling from testing.

### Thu 16 Jan 2025

Adding enemies to map.
Game balance for this will be a long, long haul...
Need to add collisions for the Phantom laser first. Started on that.
Laser detects the player.
Got to decide whether it'll 'only' do damage or if there should be a visible effect too.
(Need to make this project less work, not more...)
Aim to have full playable Alpha by Sat 25th Jan 2025.
We will see.

### Fri 17 Jan 2025

Worked on behaviour of Swarmers.
The more of them there are in the world, the faster they are.
This changes the gameplay to something more frenetic, though.
Might not want that.
More, much more testing required.
And I urgently have to get the Phantom lasers colliding reliably with the player.

### Sat 18 Jan 2025

Success with Phantom lasers. Also added particle effect for all.

### Sun 19 Jan 2025

Success adding Phantom laser collisions with Swarmers.
This will be a strategic choice by the player (or not - might be overpowered).

### Mon 20 Jan 2025

Fixed problem with all Swarmer destruction causing player damage.
New sprite for the Phantom - just a 1st draft, still not right.

### Tue 21 Jan 2025

Fixed damage collisions for Phantom.
Started on player energy logic, warnings etc.

### Wed 22 Jan 2025

Changing Swarmer behaviour - experimenting with frequency of spawn/speed.
Tentative start on BGM.
