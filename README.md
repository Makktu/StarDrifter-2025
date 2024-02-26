# SpaceLander2D (2024)

A 2D game for mobile. Distantly inspired by the 1970s arcade classic LUNAR LANDER.

Fly your spaceship through a hostile environment to the landing pad.

The spaceship is equipped with limited Energy and will have to constantly resupply en route.

Pickups come in the form of enhanced weaponry and other items.

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

