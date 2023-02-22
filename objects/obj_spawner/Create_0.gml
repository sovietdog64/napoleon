spawnRadius = 100; //Radius of spawning in pixels
amountOfEnemies = 4; //Amount of enemies to spawn
enemiesSpawned = array_create(amountOfEnemies, -1); //All instnaces spawned
spawnCooldown = 0;
maxSpawnCooldown = room_speed*5;
enemyObj = obj_enemyPathfindTemplate; //The object index of enemy to spawn
image_alpha = 0; //Makes spawner invisible

if(!layer_exists("Enemies"))
	layer_create(layer_get_depth("Instances"), "Enemies");