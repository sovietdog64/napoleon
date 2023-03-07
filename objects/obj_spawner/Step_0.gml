var spawnEnemies = true;
for(var i=0; i<array_length(enemiesSpawned); i++) {
	if(instance_exists(enemiesSpawned[i])) {
		spawnEnemies = false;
		break;
	}
	else
		spawnEnemies = true;
}

//Spawn enemies if all previously spawned enemies are dead.
if(spawnEnemies) {
	enemiesSpawned = [];
	//spawn enemies based on range
	repeat(irandom_range(minEnemies, maxEnemies)) {
		//ellipse fitting dung room size.
		var p = randPointInEllipse(elipseW, elipseH);
		var obj = enemyObj;
		if(is_array(enemyObj)) { 
			obj = randomValueFromArray(enemyObj)
		}
		var inst = instance_create_layer(
			x+p.x, y+p.y, "Instances", enemyObj
		)
		array_push(enemiesSpawned, inst);
	}
}