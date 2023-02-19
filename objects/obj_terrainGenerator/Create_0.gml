allChunks = 0;

placeSprites = function() {
	for(var xx=0; xx<ds_grid_width(terrainMap); xx++)
		for(var yy=0; yy<ds_grid_height(terrainMap); yy++) {
			var ind = numRound(ds_grid_get(terrainMap, xx, yy))
			placeTile(ind, xx, yy);
		}
}

placeChunk = function(chunkMapX, chunkMapY) {
	if(!is_struct(allChunks[# chunkMapX, chunkMapY]))
		allChunks[# chunkMapX, chunkMapY] = {
			structures : [],
		}
	var startX = chunkMapX * CHUNK_W;
	var startY = chunkMapY * CHUNK_H;
	var numGroundTiles = 0;
	var numWaterTiles = 0;
	for(var xx=startX; xx<startX+CHUNK_W; xx++)
		for(var yy=startY; yy<startY+CHUNK_H; yy++) {
			var ind = numRound(ds_grid_get(terrainMap, xx, yy))
			var tileType = placeTile(ind, xx, yy);
			if(tileType == structureTypes.GROUND)
				numGroundTiles++;
			else if(tileType == structureTypes.WATER)
				numWaterTiles++;
		}
	//Spawning structures
	//if most were ground tiles, spawn ground structure
	if(numGroundTiles/CHUNK_AREA >= 0.5) {
		
		//Spawn player in random pos
		if(playerSpawnSetup) {
			playerSpawnSetup = false;
			var playerSpawnX = irandom_range(chunkMapX*PX_CHUNK_W, chunkMapX*PX_CHUNK_W + PX_CHUNK_W);
			var playerSpawnY = irandom_range(chunkMapY*PX_CHUNK_W, chunkMapY*PX_CHUNK_W + PX_CHUNK_W);
			instance_create_layer(playerSpawnX, playerSpawnY, "Instances", obj_player);
		
			var chestSpawnX = irandom_range(chunkMapX*PX_CHUNK_W, chunkMapX*PX_CHUNK_W + PX_CHUNK_W);
			var chestSpawnY = irandom_range(chunkMapY*PX_CHUNK_W, chunkMapY*PX_CHUNK_W + PX_CHUNK_W);
			var bonusChest = instance_create_layer(playerSpawnX, playerSpawnY, "Interactables", obj_chest);
			bonusChest.items = [new Item(spr_woodHatchet, 1, 2, "Wood Hatchet", "A simple wood hatchet.\nDamage: 2", itemAnimations.KNIFE_STAB)];
		}
		
		
		var spawnX = irandom_range(chunkMapX*PX_CHUNK_W, chunkMapX*PX_CHUNK_W + PX_CHUNK_W);
		var spawnY = irandom_range(chunkMapY*PX_CHUNK_W, chunkMapY*PX_CHUNK_W + PX_CHUNK_W);
		//10% chance of village spawn in this chunk
		if(irandom(100) < 20) {
			var structures = allChunks[# chunkMapX, chunkMapY].structures;
			var canSpawn = true;
			for(var i=0; i<array_length(structures); i++) {
				if(structures[i].object_index == obj_testVillage)
					canSpawn = false;
			}
			if(canSpawn) {	
				var inst = instance_create_layer(spawnX, spawnY, "Structures", obj_testVillage);
				array_push(structures, inst);
			}
		}
	}
	
	//if most were ground tiles, spawn ground structure
	else if(numWaterTiles/CHUNK_AREA >= 0.5) {
	
	}
		
}

placeTile = function(_mapIndex, xx, yy, lay2 = layer_get_id("OnGround"), lay = layer_get_id("Ground")) {
	var sprToDraw;
	var possibleStructure = structureTypes.GROUND;
	switch(_mapIndex) {
		case 0: {
			sprToDraw = undefined;
			instance_create_layer(xx*TILEW, yy*TILEW, lay, obj_water);
			possibleStructure = structureTypes.WATER;
		}break;
		case 1: {
			sprToDraw = spr_sand;
			layer_sprite_create(lay, xx*TILEW, yy*TILEH, sprToDraw);
			if(random(1) < 0.01)
				instance_create_layer(xx*TILEW, yy*TILEW, lay2, obj_tree).sprite_index = spr_palmTree;
		}break;
		case 2: {
			sprToDraw = spr_grass;
			layer_sprite_create(lay, xx*TILEW, yy*TILEH, sprToDraw);
			if(random(1) < 0.01)
				instance_create_layer(xx*TILEW, yy*TILEW, lay2, obj_tree);
		}break;
		case 3: {
			sprToDraw = spr_grass;
			var spr = layer_sprite_create(lay, xx*TILEW, yy*TILEH, sprToDraw);
			var c = choose(make_color_rgb(144, 252, 3), make_color_rgb(177, 252, 3));
			layer_sprite_blend(spr, c);
		}break;
		case 4: {
			sprToDraw = spr_grass;
			var spr = layer_sprite_create(lay, xx*TILEW, yy*TILEH, sprToDraw);
			var c = choose(make_color_rgb(104, 168, 2), make_color_rgb(124, 168, 2));
			layer_sprite_blend(spr, c);
		}break;
		case 5: {
			sprToDraw = spr_grass;
			var spr = layer_sprite_create(lay, xx*TILEW, yy*TILEH, sprToDraw);
			var c = choose(make_color_rgb(95, 153, 3), make_color_rgb(82, 117, 1));
			layer_sprite_blend(spr, c);
		}break;
		case 6: {
			sprToDraw = spr_grass;
			var spr = layer_sprite_create(lay, xx*TILEW, yy*TILEH, sprToDraw);
			var c = choose(make_color_rgb(51, 66, 2), make_color_rgb(63, 82, 2));
			layer_sprite_blend(spr, c);
			if(random(1) < 0.4)
				instance_create_layer(xx*TILEW, yy*TILEW, lay2, obj_tree);
		}break;
		case 7: {
			sprToDraw = spr_grass;
			var spr = layer_sprite_create(lay, xx*TILEW, yy*TILEH, sprToDraw);
			var c = choose(make_color_rgb(78, 102, 1), make_color_rgb(66, 87, 1));
			layer_sprite_blend(spr, c);
			if(random(1) < 0.4)
				instance_create_layer(xx*TILEW, yy*TILEW, lay2, obj_tree);	
		}break;
		case 8: {
			sprToDraw = spr_grass6;
			layer_sprite_create(lay, xx*TILEW, yy*TILEH, sprToDraw);
		}break;
		case 9: {
			sprToDraw = spr_dirt;
			layer_sprite_create(lay, xx*TILEW, yy*TILEH, sprToDraw);
		}
		case 10: {
			sprToDraw = spr_sand;
			layer_sprite_create(lay, xx*TILEW, yy*TILEH, sprToDraw);
			if(random(1) < 0.01)
				instance_create_layer(xx*TILEW, yy*TILEW, lay2, obj_tree).sprite_index = spr_palmTree;
		}break;
		default: {
			sprToDraw = undefined;
			instance_create_layer(xx*TILEW, yy*TILEW, lay, obj_water);
			possibleStructure = structureTypes.WATER;
		}break;
	}
	return possibleStructure;
}
	
playerSpawnSetup = true;