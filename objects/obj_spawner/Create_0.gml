spawnRadius = 100; //Radius of spawning in pixels
minEnemies = 4; //Amount of enemies to spawn
maxEnemies = 10;
enemiesSpawned = []; //All instnaces spawned
maxSpawnCooldown = room_speed*5;
enemyObj = obj_enemyPathfindTemplate; //The object index of enemy to spawn
hp = 100;

elipseW = 0;
	
enemiesSpawned = [-1];