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

### Tues 15 Oct 2024
Project restarted after long hiatus.

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

### Thu 23 Jan 2025

First pickups drafted (speed and energy).
Implemented, with behaviour and effects on player.

### Fri 24 Jan 2025

Refined pickups. Added energy pickups.
Working on decor ('radio towers') - replaced placeholder sprite for these.

### Sat 25 Jan 2025

Spruced up radio towers
Drafted a 'mech volcano'
Some balancing tweaks to swarmers

### Sun 26 Jan 2025

Shield pickup done.
Shield graphic added to player node.
1st draft of it in operation - work remains...

### Mon 27 Jan 2025

Tweaked shield behaviour & graphics
Tweaked Swarmer speed
Misc-other tweaks

### Tue 28 Jan 2025

Added Start screen placeholder gfx & music
Failed attempt to implement pre-boss battle zoomout and in

### Wed 29 Jan 2025

New Phantom graphic and explosion
1st draft of bullets pickup

### Thu 30 Jan 2025

Full functionality of 2 or bullets pickups added (game balancing effects TBD)
Started adding pickups strategically around the map (from Start area to bottom of 1st section)
Game is much too hard right now. Not really a game yet at all.

### Fri 31 Jan 2025

Swarmer is destroyed upon collision with player shield
(subject to change for game balancing AND technically,
because the current solution is a distance-from calculation
rather than a collision detection).

Swarmer spawning frequency change implemented as the
current opening few minutes of the game
is just too difficult otherwise.

### Sat 1 Feb 2025
*Game must reach **start-to-finish playable beta** by 14 Feb*
pickups: player can only have one active pickup at a time (by game design)

### Sun 2 Feb 2025
Happy Groundhog Day
Created a single unified pickup spawner that randomly spawns the 5x types
Worked on game logic related to this i.e. how soon (or if) another pickup
appears after one is picked up - this still needs a lot of work
and a lot of balancing with the rest of the game.

### Mon 3 Feb 2024
1st draft of 'ship throb' animation to indicate low shield & critical shield
However it's not obvious enough - need to refine
Also need to separate shield animations and the low/critical energy animations
Also need to work on logic for all the above as it's eccentric right now
Decision: no visible 'HUD' indicators for anything on-screen. Other than a faint Pause button.

### Tue 4 Feb 2025
Worked on shield logic and animations - will pulse while active,
rapidly pulse when about to expire.
(Currently all pickups are shields as still have to fine-tune the above.)
Changed damage from Phantom laser to ~15 energy per sustained hit (0.1 per frame).
Added pickups to all of first section.
Added a debug energy readout to screen.

### Thu 6 Feb 2025
(Skipped a day's work yesterday - the first since this new phase began.)
Added 1st draft of fog for world. Not satisfying to look at at the moment.
Added pew-pew-pew sound effect for player shooting. Also not great right now.

### Fri 7 Feb 2025
Fog is broken right now - trying to implement dynamic fade in and out,
not working.
Got the distribution and movement of fog working right.
While increasing player speed to test, gameplay feels more satisfying.
Speed pickups need to be more plentiful and longer-lasting than currently.

### Sat 8 Feb 2025
Very early draft of energy barriers between sections created & added

### Sun 9 Feb 2025
2nd draft of energy barrier also not-good - graphical rethink needed.
Successful tweak of collisions, now working.

### Mon 10 Feb 2025
A few drafts of energy barriers, none good.
Switched Swarmer spawnpoint graphic from particle effect to the 'radio towers',
with each Swarmer being 'techno-pollen' from the antennae. Like it so far.

### Tue 11 Feb 2025
Hit on a decent draft of the energy barrier - now got to integrate it into the game.
(And make an actual game from these and any further parts.)

### Wed 12 Feb 2025
And another poor draft of the energy barrier. None yet have been right.

### Thu 13 Feb 2025
Finally a decent energy barrier. Will go with it.

### Fri 14 Feb 2025
Added basic behaviour to energy barriers. Restoration currently bugged.

### Sat 15 Feb 2025
Fixed barrier restoration after downtime. Now need to work out how player
disables the barriers.

### Sun 16 Feb 2025
Tweaked spawner behaviour.
Added global difficulty.
BIG balancing job ahead, and the game features are only ~40% done.

### Mon 17 Feb 2025
Fixed bug in fog effect. The bug was my faulty understanding of
how things work with Godot alpha values for sprites. Values range from
0.0 to 1.0. I had thought it was 0 to 255, with hilarious results.
Got a good early version of the fade in/fade out script work,
with predictable intervals and transparencies for now.

### Tue 18 Feb 2025
1st draft of energy barrier 'nodes' that the player shoots to disable the barriers
temporarily. Will all need linking up still. And graphical boosts.

### Wed 19 Feb 2025
Interrupted workday - managed to get energy barrier node logic running. 
Currently game is in no-enemies, no-damage mode while I fine-tune.
Got to decide whether one or both power supply nodes
being disabled can interrupt the barrier. Current setup isn't intuitive
enough for the player.

### Thu 20 Feb 2025
Re-org of node structure in World scene tree. All entities in their own nodes.
1st draft of powerline structure leading from generators to barriers. Not good,
and deleted. The barrier is a key gameplay element and can't be skimped on.
May use CPU particle effect.

### Fri 21 Feb 2025
Trying particles effect for barrier powerline. Not working currently. It will.

### Sat 22 Feb 2025
Abandoned the particles effect for the powerline thing. Not working. Will have
to be either graphical lines overlaid onto the map or nothing.
Tweaking spawner and swarmer behaviours.

### Sun 23 Feb 2025
Changed power node emitters to one unit only - simplifies the
big game balancing challenge coming soon. Implemented the logic. Is working.

### Mon 24 Feb 2025
Advance made on power node logic, 1st draft implemented. Timing bug presently.

### Tue 25 Feb 2025
Fixed timing bug on power nodes. 1st proper implementation.
Next step: spawning enemies

### Wed 26 Feb 2025
New bug apparent in testing barrier nodes and barriers.
Starting the laying out of barriers.
None of this feels right currently.
New enemies need to be added. Currently only 2. Need 8 or so.

### Thu 27 Feb 2025
Laying out energy barriers across the map.
Operation still slightly bugged. Works, but not predictably enough
for gamer satisfaction. The duration of them being disabled
must always be the same - 10 seconds.

### Fri 28 Feb 2025
Tried another version of the barrier. Again not satisfactory.

### Sat 1 Mar 2025
still working on the energy barrier. Particle effect when active across
its width and height makes it look much better, but the overall
'barrierness' is still not right. Need a new concept for it or to improve
either of the two existing beyond current levels.

### Mon 3 Mar 2025
Another day off yesterday - only the 2nd since this new phase began.
Today: work on the energy barrier. Switching away from imported sprite-based
graphics to a particles node. Much more promising. 

### Tue 4 Mar 2025
Still problem with updated Godot not showing laser particle effects.
Worked on appearance of barrier - still poor logic to behaviour though.

### Wed 5 Mar 2025
Found the phantom laser particle effect bug (simple z-index thing...).

### Thu 6 Mar 2025
Back to making the Phantoms fade in and out - working on logic, game balance etc.

### Fri 7 March 2025
Changed barrier generator gfx and worked on behaviour.

### Sat 8 March 2025
Phantom scene needed work to resolve transform area.

### Sun 9 March 2025
Major rethink of swarmer spawner begun.

### Mon 10 March 2025
Rethink of swarmer spawner complete.
Change to barrier graphics.
(Consider wormhole passage after beating enemies?)

### Tue 11 March 2025
Urgently needs Swarmer refinement.
And barrier refinement.
Tried a couple of things ('wormholing' past barriers, and Swarmers
exploding on any collision) that didn't quite work. Yet?

### Wed 12 March 2025
Everything needs a rethink:
	- bring back the radio tower spawner spawn concept
	- add another 2x enemies (maybe 3x or 4x?)
	- increase the speed and manoeuverability of the player craft
	- make 'fog' affect speed (why? because!)
	- make the barrier power nodes (if the concept stays) part of the barrier scene
	- get a ruined planet/space station in there - decor for the environment too
	
### Thu 13 March 2025
Started on fog-speed effect - focus on that tomorrow.

### Fri 14 March 2025
Fog speed effect not good.
Changed spawner swarmer again.

### Sat 15 March 2025
New direction for the energy towers -
and a new conception of the game world overall.
"The automated ruins of a civilization."

### Mon 17 March 2025
Working on barrier logic, is broken again.

### Tue 18 March 2025
Got barriers working properly.

### Wed 19 March 2025
Barriers bugged again.

### Thu 20 March 2025
Worked on barrier logic. Problem of managing global timeout for power
and keeping all animations consistent. Some are not starting/restarting
logically.

### Tues 25 March 2025
Project had a 'week off' for 'creative refreshment'.
Need to get a lot of things actually done.
And decided, gameplay and atmosphere-wise.

### Wed 26 March 2025
To be done:
	Barriers (STILL not right - how long has this been dragging on now?)
	New enemies (at least 2 needed, possibly more)
	
### Thu 27 March 2025
I'm tired of these ************ barriers in this ************ game!
They're being completely redone now.
Thought I had them working again, but no, the spaghetti is too tangled.
Complete re-do of the code, no more fixing.
Will need to use Animation Player node,
rather than doing rotation in the _process function. 🔫

### Mon 31 March 2025
Added animation player to barrier rotation. Logic still not reliable.

### Wed 2 April 2025
Barriers seem OK to work with for now.
Tweaked animations on spawner towers.

### Thu 3 April 2025
Working on swarmer spawners.
Making the tower move vertically up - just an experiment for now.
Changed swarmers to be one-shot destroyed.

### Fri 4 April 2025
Rolled back on the new swarmer spawners.
Taken the mechanic - tower launching - and started on new enemy.

### Sat 5 April 2025
New enemy missile has several behaviours that could spin off into new enemies.
Will consider.

### Sun 6 April 2025
Work on enemy missile - is a one-shot thing, pretty easy to avoid, but
instant game over if struck. Couple of animations. Missile is a simple
graphic that probably is OK as-is, in keeping with game aesthetic.

### Mon 14 April 2025
Small work on missiles - not satisfactory at all.
Movement logic bad.

### Tue 15 April 2025
Missiles re-thought: will rotate to present flat edge to player and then
zoom at high speed. Looks and feels interesting. Logic trouble as ever.
Need to set strict lifespan timer then queue_free()
(instead of on-screen notifier queue_free()) as it currently
means some missiles never fire.

### Wed 16 April 2025
Worked on the Pusher - can beef these up as they work great.
Might switch to player activation through proximity rather
than on-screen notification activation, as this latter is
working patchily right now (unwanted behaviours when player
flies off-screen in other direction etc.).

### Thu 17 April 2025
Pusher now added to Swarmer spawnpoint. Will need to adjust to be one or 
the other, or handle the which-one logic better.

### Fri 18 April 2025
Worked on enemy spawner behaviour, particles etc.

### Sat 19 April 2025
Improved Pusher behaviour.

### Sun 20 April 2025
The bumps.

### Mon 21 April 2025
Added some test décor and 1st draft of new enemy type: Hunter.
Just concepts for now.

### Tue 22 April 2025
Testing ideas for the Hunter enemy -
proximity increases rotation, ignores environment etc. Early days.

### Wed 23 April 2023
Very promising Hunter developments. Behaviour and scope.

### Thu 24 April 2025
Not-so-promising attempt to add particle effect to Hunter.
Problem is the current sprite is a placeholder and it's not worth
working on further unless it's the final sprite, or near to final.

### Fri 25 April 2025
Experimenting with different looks for the Hunter.
Settled on a kind of mobile crosshair that will be animated when
in proximity to player - sparks, ideally. 

### Sat 26 April 2025
Near-final concept for Hunter. Graphics still dubious.
Collisions not working correctly yet

### Sun 27 April 2025
Hunter collisions & behaviour now working as desired.

### Mon 28 April 2025
Added animation and explosion to Hunter on its death.

### Thu 1 May 2025
Improved hunter global activation logic & death animation

### Fri 2 May 2025
Started implemeting universal speed that all objects will move in relation to.
Also, Regular Mode and Arcade Mode idea.

### Sat 3 May 2025
Working on arcade/regular mode toggle

### Sun 4 May 2025
Moved Arcade/Regular toggle into Start menu.
Values will need lots of testing.

### Mon 5 May 2025
Starting to fill out the rest of the map with enemies
Worked on the Hunter - will increase in size with additional speed (impose limit)

### Tue 6 May 2025
Refining the Hunter scaling effect over time - still work to do

### Wed 7 May 2025
Added new enemy spawning animation.
