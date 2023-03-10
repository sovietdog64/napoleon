function placeChunk(chunkMapX, chunkMapY) {
	var chunk = allChunks[# chunkMapX, chunkMapY];
	
	
	var startX = chunkMapX * CHUNK_W;
	var startY = chunkMapY * CHUNK_H;
	var tiles = ds_list_create();
	for(var xx=startX; xx<startX+CHUNK_W; xx++)
		for(var yy=startY; yy<startY+CHUNK_H; yy++) {
			var ind = numRound(ds_grid_get(terrainMap, xx, yy))
			var tile = placeTile(ind, xx, yy);
			if(tile != undefined)
				ds_list_add(tiles, tile);
		}
	chunk.tiles = tiles;
}

function placeChunkStruct(chunk) {
	
	var startX = chunk.mapX * CHUNK_W;
	var startY = chunk.mapY * CHUNK_H;
	var tiles = ds_list_create();
	for(var xx=startX; xx<startX+CHUNK_W; xx++)
		for(var yy=startY; yy<startY+CHUNK_H; yy++) {
			var ind = numRound(ds_grid_get(terrainMap, xx, yy))
			var tile = placeTile(ind, xx, yy);
			if(tile != undefined)
				ds_list_add(tiles, tile);
		}
	chunk.tiles = tiles;
	
	for(var i=0; i<ds_list_size(chunk.instances); i++)
		instance_activate_object(chunk.instances[| i])

	variable_struct_set(chunk, "loaded", true)
}

function updateChunkInstances(chunkMapX, chunkMapY) {
	var chunk = allChunks[# chunkMapX, chunkMapY];
	//list of all instances
	var list = ds_list_create();
	var chunkX = chunkMapX*PX_CHUNK_H;
	var chunkY = chunkMapY*PX_CHUNK_H;
	//Get all instances
	collision_rectangle_list(
		chunkX, chunkY,
		chunkX+PX_CHUNK_H, chunkY+PX_CHUNK_H,
		all, 0, 1, list, 0
	);
	
	//save instances to chunk
	chunk.instances = list;
}

function prepareChunk(chunkMapX, chunkMapY) {
	allChunks[# chunkMapX, chunkMapY] = {
		structures : [],
		structureType : structureTypes.ALL,
		loaded : false,
		prepared : false,
		instances : ds_list_create(),
		tiles : ds_list_create(),
		mapX : chunkMapX,
		mapY : chunkMapY,
	}
	
	var chunk = allChunks[# chunkMapX, chunkMapY];
	if(chunk.prepared)
		return;
	chunk.prepared = true;
	var startX = chunkMapX * CHUNK_W, 
		startY = chunkMapY * CHUNK_W;
	var numGroundTiles = 0, 
		numWaterTiles = 0;
	
	//Getting chunk strucutre type + structure spawning
	for(var xx=startX; xx<startX+CHUNK_W; xx++)
		for(var yy=startY; yy<startY+CHUNK_H; yy++) {
			var ind = numRound(terrainMap[# xx, yy]);
			var tileType = getTileType(ind);
			
			//Spawning strucutres depending on 
			if(ind == 6 || ind == 7) {
				//goblin villages in woods
				if(random(1) < 0.001) {
					var inst = spawnStructure(chunkMapX, chunkMapY, xx*TILEW, yy*TILEW, obj_goblinVillage);
					if(inst != undefined)
						array_push(chunk.structures, inst);
				}
			}
			if(tileType == structureTypes.GROUND)
				numGroundTiles++;
			else if(tileType == structureTypes.WATER)
				numWaterTiles++;
		}
		
	//Spawning structures
	//if most were ground tiles, spawn ground structure + player spawn
	if(numGroundTiles/CHUNK_AREA >= 0.5) {
		
		chunk.structureType = structureTypes.GROUND;
		
		//Spawn player in random pos
		if(playerSpawnSetup && irandom(100) < 20) {
			playerSpawnSetup = false;
			var playerSpawnX = irandom_range(chunkMapX*PX_CHUNK_W, chunkMapX*PX_CHUNK_W + PX_CHUNK_W);
			var playerSpawnY = irandom_range(chunkMapY*PX_CHUNK_W, chunkMapY*PX_CHUNK_W + PX_CHUNK_W);
			instance_create_layer(playerSpawnX, playerSpawnY, "Instances", obj_player);
			giveItemToPlayer(new WoodHatchet())
			//var chestSpawnX = irandom_range(chunkMapX*PX_CHUNK_W, chunkMapX*PX_CHUNK_W + PX_CHUNK_W);
			//var chestSpawnY = irandom_range(chunkMapY*PX_CHUNK_W, chunkMapY*PX_CHUNK_W + PX_CHUNK_W);
			//var bonusChest = instance_create_layer(playerSpawnX, playerSpawnY, "Interactables", obj_chest);
			//bonusChest.items = [new WoodHatchet()];
		}
		
		var spawnX = irandom_range(chunkMapX*PX_CHUNK_W, chunkMapX*PX_CHUNK_W + PX_CHUNK_W);
		var spawnY = irandom_range(chunkMapY*PX_CHUNK_W, chunkMapY*PX_CHUNK_W + PX_CHUNK_W);
		//15% chance of village spawn in this chunk
		if(irandom(100) < 15) 
			spawnStructure(chunkMapX, chunkMapY, spawnX, spawnY, obj_testVillage);
		
	}
	
	//If most were water tiles, spawn water structure (not added yet)
	else if(numWaterTiles/CHUNK_AREA >= 0.5) {
		chunk.structureType = structureTypes.WATER;
	}
}

function spawnStructure(chunkMapX, chunkMapY, spawnX, spawnY, obj, lay = "Structures", varStruct = undefined) {
	var structures = allChunks[# chunkMapX, chunkMapY]
	var canSpawn = true;
	for(var i=0; i<array_length(structures); i++) {
		if(structures[i].object_index == obj)
			canSpawn = false;
	}
		
	//If there isn't any other strucutre like this one in the chunk, spawn it
	if(canSpawn) {
		var inst;
		if(is_struct(varStruct))
			inst = instance_create_layer(spawnX, spawnY, lay, obj, varStruct);
		else
			inst = instance_create_layer(spawnX, spawnY, lay, obj);
		return inst;
	}
	//do not return the structure instance if couldn't spawn
	else
		return undefined;
}

function placeTile(_mapIndex, xx, yy, lay2 = layer_get_id("OnGround"), lay = layer_get_id("Ground")) {
	var spr = undefined;
	var obj = undefined;
	var objSpr = undefined;
	var blend = undefined;
	var objLayer = lay2;
	var sprLayer = lay;
	switch(_mapIndex) {
		case 0: {
			obj = obj_water;
			objLayer = lay;
		}break;
		case 1: {
			spr = spr_sand;
			if(random(1) < 0.01) {
				obj = obj_tree;
				objSpr = spr_palmTree;
			}
		}break;
		case 2: {
			spr = spr_grass;
			if(random(1) < 0.01)
				obj = obj_tree
		}break;
		case 3: {
			spr = spr_grass;
			blend = choose(make_color_rgb(144, 252, 3), make_color_rgb(177, 252, 3));
			if(random(1) < 0.01)
				obj = obj_tree;
		}break;
		case 4: {
			spr = spr_grass;
			blend = choose(make_color_rgb(104, 168, 2), make_color_rgb(124, 168, 2));
			if(random(1) < 0.015)
				obj = obj_tree;
		}break;
		case 5: {
			spr = spr_grass;
			blend = choose(make_color_rgb(95, 153, 3), make_color_rgb(82, 117, 1));
		}break;
		case 6: {
			spr = spr_grass;
			blend = choose(make_color_rgb(51, 66, 2), make_color_rgb(63, 82, 2));
			if(random(1) < 0.2)
				obj = obj_tree;
		}break;
		case 7: {
			spr = spr_grass;
			blend = choose(make_color_rgb(78, 102, 1), make_color_rgb(66, 87, 1));
			if(random(1) < 0.2)
				obj = obj_tree
		}break;
		case 8: {
			spr = spr_grass6;
			if(random(1) < 0.2)
				obj = obj_tree;
		}break;
		case 9: {
			spr = spr_dirt;
		}
		case 10: {
			spr = spr_sand;
		}break;
		default: {
			obj = obj_water;
			objLayer = lay;
		}break;
	}
	
	var returnVal = undefined;
	
	//Placing tiles/spawning objects accordingly
	if(spr != undefined) {
		var s = layer_sprite_create(sprLayer, xx*TILEW, yy*TILEW, spr);
		if(blend != undefined)
			layer_sprite_blend(s, blend);
		returnVal = s;
	}
	
	if(obj != undefined) {
		var inst = instance_create_layer(xx*TILEW, yy*TILEH, objLayer, obj);
		if(objSpr != undefined)
			inst.sprite_index = objSpr;
	}
	return returnVal;
}

function getTileType(_mapIndex) {
	var possibleStructure = structureTypes.GROUND;
	switch(_mapIndex) {
		case 0: {
			possibleStructure = structureTypes.WATER;
		}break;
		case 1: {
			
		}break;
		case 2: {
			
		}break;
		case 3: {
			
		}break;
		case 4: {
			
		}break;
		case 5: {
			
		}break;
		case 6: {
			
		}break;
		case 7: {
			
		}break;
		case 8: {
			
		}break;
		case 9: {
			
		}
		case 10: {
			
		}break;
		default: {
			possibleStructure = structureTypes.WATER;
		}break;
	}
	return possibleStructure;
}
