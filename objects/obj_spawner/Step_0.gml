if(spawnCooldown > 0)spawnCooldown--;
else {
	for(var i=0; i<amountOfEnemies; i++) {
		if(layer_has_instance("Enemies", enemiesSpawned[i]))
			continue;
		else  {
			var iterations = 0;
			var xx = x;
			var yy = y;
			//Finding valid position for enemy
			while(true) {
				//Raycast in ranomd directions and distances from self
				var angle = irandom(360);
				var dist = irandom(spawnRadius);
				xx = x+(dist*dcos(angle));
				yy = y+(-dist*dsin(angle));
				if(place_free(xx, yy) && collision_line(x, y, xx, yy, obj_solid, 0, 1) == noone) {
					break;
				}
				//If couldn't find position for enemy in 50 loops, spawn on self
				iterations++;
				if(iterations > 50) {
					xx = x;
					yy = y;
					break;
				}
			}
			enemiesSpawned[i] = instance_create_layer(xx, yy, "Enemies", enemyObj);
		}
	}
	spawnCooldown = maxSpawnCooldown;
}