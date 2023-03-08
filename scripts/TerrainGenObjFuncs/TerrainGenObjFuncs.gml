function placeChunk(chunkMapX, chunkMapY) {
	var chunk = global.chunksGrid[# chunkMapX, chunkMapY];
	
	var startX = chunkMapX * CHUNK_W;
	var startY = chunkMapY * CHUNK_H;
	for(var xx=startX; xx<startX+CHUNK_W; xx++)
		for(var yy=startY; yy<startY+CHUNK_H; yy++) {
			var ind = numRound(ds_grid_get(global.terrainGrid, xx, yy))
			placeTile(ind, xx, yy, chunk.previouslyLoaded);
		}
}

function placeChunkStruct(chunk) {
	
	var startX = chunk.mapX * CHUNK_W;
	var startY = chunk.mapY * CHUNK_H;
	for(var xx=startX; xx<startX+CHUNK_W; xx++)
		for(var yy=startY; yy<startY+CHUNK_H; yy++) {
			var ind = numRound(ds_grid_get(global.terrainGrid, xx, yy))
			placeTile(ind, xx, yy);
		}

	variable_struct_set(chunk, "loaded", true)
}

function prepareChunk(chunkMapX, chunkMapY) {
	global.chunksGrid[# chunkMapX, chunkMapY] = {
		structures : [],
		structureType : structureTypes.ALL,
		loaded : false,
		prepared : false,
		previouslyLoaded : false,
		mapX : chunkMapX,
		mapY : chunkMapY,
	}
	
	var chunk = global.chunksGrid[# chunkMapX, chunkMapY];
	if(chunk.prepared)
		return;
	chunk.prepared = true;
	var startX = chunkMapX * CHUNK_W, 
		startY = chunkMapY * CHUNK_W;
	var numGroundTiles = 0, 
		numWaterTiles = 0;
	
	
	//Getting chunk strucutre type + misc structure spawning
	for(var xx=startX; xx<startX+CHUNK_W; xx++)
		for(var yy=startY; yy<startY+CHUNK_H; yy++) {
			var ind = numRound(global.terrainGrid[# xx, yy]);
			var tileType = getTileType(ind);
			
			//goblin villages in woods
			if(ind == 6 || ind == 7) {
				if(random(1) < 0.001) {
					var canSpawn = true;
					
					for(var i=0; i<array_length(chunk.structures); i++) {
						if(chunk.structures[i] == obj_goblinVillage) {
							canSpawn = false;
							break;
						}
					}
					
					if(canSpawn)
						array_push(chunk.structures, instance_create_layer(
							xx*TILEW, yy*TILEW,
							"Structures",
							obj_goblinVillage
						));
				}
			}

			if(tileType == structureTypes.GROUND)
				numGroundTiles++;
			else if(tileType == structureTypes.WATER)
				numWaterTiles++;
		}
	
	//Setting chunk structure types
	if(numGroundTiles/CHUNK_AREA >= 0.5) {
		
		chunk.structureType = structureTypes.GROUND;
		
		//var spawnX = irandom_range(chunkMapX*PX_CHUNK_W, chunkMapX*PX_CHUNK_W + PX_CHUNK_W);
		//var spawnY = irandom_range(chunkMapY*PX_CHUNK_W, chunkMapY*PX_CHUNK_W + PX_CHUNK_W);
		////15% chance of village spawn in this chunk
		//if(irandom(100) < 15) 
		//	spawnStructure(chunkMapX, chunkMapY, spawnX, spawnY, obj_testVillage);
		
	}
	
	else if(numWaterTiles/CHUNK_AREA >= 0.5) {
		chunk.structureType = structureTypes.WATER;
	}
	
}

function spawnStructure(chunkMapX, chunkMapY, obj, lay = "Structures", varStruct = undefined) {
	
	{//Return undefined if there is a strucutre like this one nearby.
		//This chunk of code just checks if a chunk nearby contains a structure that is similar to this one (same object index as param "obj"). 
		//It checks the chunks in the 4 cardinal directions relative to this chunk.
		
		var gridX = chunkMapX;
		var gridY = chunkMapY;
		
		//Stop spawning structure if the chunk its in already has one of its self
		var chunkStructures = global.chunksGrid[# gridX, gridY].structures;	
			
		for(var j=0; j<array_length(chunkStructures); j++) {
			var structure = chunkStructures[j];
			if(structure.object_index == obj)
				return undefined;
		}
		
		for(var i=0; i<4; i++) {
			var gridX = chunkMapX;
			var gridY = chunkMapY;
			
			//Get the chunk to check
			switch(i) {
				case 0 :  //Left
					gridX--;
					break;
					
				case 1 : //Right
					gridX++;
					break;
					
				case 2 : //Up
					gridY--;
					break;
					
				case 3 : //Down
					gridY++;
					break;
			}
			
			if(!withinBoundsGrid(global.chunksGrid, gridX, gridY))
				continue;
				
			chunkStructures = global.chunksGrid[# gridX, gridY].structures;
			
			
			for(var j=0; j<array_length(chunkStructures); j++) {
				var structure = chunkStructures[j];
				if(structure.object_index == obj)
					return undefined;
			}
		}
	}
	
	//If there isn't any other structure like this one nearby, spawn one
	var inst;
	var pxChunkX = chunkMapX*PX_CHUNK_W;
	var pxChunkY = chunkMapY*PX_CHUNK_H;
	var spawnX = irandom_range(pxChunkX, pxChunkX+PX_CHUNK_W);
	var spawnY = irandom_range(pxChunkY, pxChunkY+PX_CHUNK_W);
	
	if(is_struct(varStruct))
		inst = instance_create_layer(spawnX, spawnY, lay, obj, varStruct);
	else
		inst = instance_create_layer(spawnX, spawnY, lay, obj);
	return inst;
}

function placeTile(_mapIndex, xx, yy, chunkPrevLoaded, lay2 = layer_get_id("OnGround"), lay = layer_get_id("Ground")) {
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
		
		//If chunk previously loaded & object being made is not a tile, then stop making the object
		if(chunkPrevLoaded && !object_is_ancestor(obj, obj_tilePar))
			return returnVal;
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
