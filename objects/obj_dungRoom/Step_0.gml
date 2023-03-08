if(variable_instance_exists(id, "isSpawnRoom") && isSpawnRoom)
	return;

if(global.dead) {
	wavesStarted = false;
	if(instance_exists(obj_dungeonDoor))
		obj_dungeonDoor.solid = false;
		
	return;
}

if(roomType == dungRoomTypes.ENEMY && !roomDone) {	
	if(initialEnemies) {
		initialEnemies = false;
		repeat(irandom_range(5, 10)) {
			var p = randPointInEllipse(rmWidth - TILEW*2, rmHeight - TILEW*2);
			var inst = instance_create_layer(
				cellMid.x + p.x, cellMid.y + p.y,"Instances",
				choose(obj_dungeonGen.enemy1Obj, obj_dungeonGen.enemy2Obj, obj_dungeonGen.enemy3Obj)
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
				
			//Spawning new enemies for next wave
			if(makeNewWave) {
				waves--;
				roomEnemies = [];
				//Spawn enemies for this new wave
				repeat(irandom_range(7, 15)) {
					//Rand point in room for enemy to spawn.
					var p = randPointInEllipse(rmWidth - TILEW*2, rmHeight - TILEW*2);
					var inst = instance_create_layer(
						cellMid.x + p.x, cellMid.y + p.y,"Instances",
						choose(obj_dungeonGen.enemy1Obj, obj_dungeonGen.enemy2Obj, obj_dungeonGen.enemy3Obj)
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
			enemyObj = [obj_dungeonGen.enemy1Obj, obj_dungeonGen.enemy2Obj, obj_dungeonGen.enemy3Obj];
			elipseW = other.rmWidth-TILEW*2;
			elipseH = other.rmHeight-TILEW*2;
		}
	}
}
	
else if(spawnMerchant && roomType == dungRoomTypes.MERCHANT) {
	spawnMerchant = false;
	
	var numOfItems = irandom_range(3, rmWidth div (ITEM_SIZE*0.4+TILEW));
	numOfItems = clamp(numOfItems, 1, array_length(obj_dungeonGen.itemsSold)/2);
	
	var shopItems = array_create(numOfItems);
	
	var org = new Point(cellMid.x, cellMid.y+TILEW*3);
	org.x -= (numOfItems/2)*(ITEM_SIZE*0.4+TILEW);
	
	for(var i=0; i<numOfItems; i++) {
		var item = randomValueFromArray(obj_dungeonGen.itemsSold);
		while(array_contains(shopItems, item))
			item = randomValueFromArray(obj_dungeonGen.itemsSold);
		
		shopItems[i] = item;
		
		instance_create_layer(
			org.x+(ITEM_SIZE*0.4+TILEW)*i, org.y,
			"Instances", obj_shopItem,
			{
				item : item,
				price : obj_dungeonGen.itemPrices[i]
			}
		)
		
	}
	
}

else if(spawnChest && roomType == dungRoomTypes.CHEST) {
	spawnChest = false;
	chest = instance_create_layer(cellMid.x, cellMid.y,"Instances", obj_chest)
	chest.items[0] = randomValueFromArray(obj_dungeonGen.chestItems);
	show_debug_message(obj_dungeonGen.chestItems)
}