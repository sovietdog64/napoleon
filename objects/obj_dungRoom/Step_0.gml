if(roomType == dungRoomTypes.ENEMY && !roomDone) {	
	if(initialEnemies) {
		initialEnemies = false;
		repeat(irandom_range(5, 10)) {
			var p = randPointInEllipse(rmWidth - TILEW*2, rmHeight - TILEW*2);
			var inst = instance_create_layer(
				cellMid.x + p.x, cellMid.y + p.y,"Instances",
				choose(obj_dungeonGen.enemy1, obj_dungeonGen.enemy2, obj_dungeonGen.enemy3)
			)
			array_push(roomEnemies, inst);
		}
	}
	if(variable_instance_exists(id, "waves")) {
		if(!wavesStarted && point_in_rectangle(
			obj_player.x, obj_player.y,
			x+TILEW*2, y+TILEW*2,
			x+rmWidth-TILEW*2, y+rmHeight-TILEW*2)) 
		{
			wavesStarted = true;
		}
		if(wavesStarted) {
			if(instance_exists(obj_dungeonDoor))
				obj_dungeonDoor.solid = true;
			var makeNewWave = true;
			for(var i=0; i<array_length(roomEnemies); i++) {
				if(instance_exists(roomEnemies[i]))
					makeNewWave = false;
			}
			if(makeNewWave) {
				waves--;
				roomEnemies = [];
				//Spawn enemies for this new wave
				repeat(irandom_range(7, 15)) {
					show_debug_message("ee")
					//Rand point in room for enemy to spawn.
					var p = randPointInEllipse(rmWidth - TILEW*2, rmHeight - TILEW*2);
					var inst = instance_create_layer(
						cellMid.x + p.x, cellMid.y + p.y,"Instances",
						choose(obj_dungeonGen.enemy1, obj_dungeonGen.enemy2, obj_dungeonGen.enemy3)
					)
					array_push(roomEnemies, inst);
				}
				if(waves <= 0) {
					roomDone = true;
					if(instance_exists(obj_dungeonDoor))
						obj_dungeonDoor.solid = false;
				}
			}
		
		}
	}
	else if(createSpawners) {
		createSpawners = false;
		with(instance_create_layer(cellMid.x, cellMid.y, "Instances", obj_spawner)) {
			enemyObj = [obj_dungeonGen.enemy1, obj_dungeonGen.enemy2, obj_dungeonGen.enemy3];
			elipseW = other.rmWidth-TILEW*2;
			elipseH = other.rmHeight-TILEW*2;
		}
	}
}