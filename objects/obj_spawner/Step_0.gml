for(var i=0; i<array_length(enemiesSpawned); i++) {
	if(instance_exists(enemiesSpawned[i]))
		return;
}

//Empty array of non-existing enemies first
enemiesSpawned = [];

//Spawning random amount of enemies
repeat(irandom_range(minEnemies, maxEnemies)) {
	var obj = is_array(enemyObj) ? randomValueFromArray(enemyObj) : enemyObj;
	if(!object_exists(obj))
		continue;
	var p = randPointInEllipse(elipseW, elipseH);
	var inst = instance_create_depth(x + p.x, y + p.y, 0, obj, {dungRoom : dungRoom});
	//Add new enemy to enemies-spawned
	array_push(enemiesSpawned, inst);
}