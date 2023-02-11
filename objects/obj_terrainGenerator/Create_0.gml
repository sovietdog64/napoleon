function spawnTiles(terrainMap, sprite, spriteOrder, startX, startY, object = -1, invertPlacement = false, isBaseTile = false, randomizeAngle = true) {
	var genX = startX;
	var genY = startY;
	var spriteToDraw = sprite;
	if(is_array(sprite))
		spriteToDraw = sprite[0];
	var lay = layer_create(layer_get_depth(layerId) - spriteOrder, sprite_get_name(spriteToDraw) + " layer");
	var spacing = TILEW;
	for(var col = 0; col < terrainMap.width; col++) {
		for(var row = 0; row < terrainMap.height; row++) {
			if(is_array(sprite))
				spriteToDraw = sprite[0];
			if(!invertPlacement) {
				if(terrainMap.map[col][row]) {
					genX = col*spacing + startX;
					genY = row*spacing + startY;
					var spr = layer_sprite_create(lay, genX, genY, spriteToDraw);
					if(randomizeAngle)
						layer_sprite_angle(spr, choose(0, 90, 180, 270));
					if(object != -1) {
						if(is_array(object)) {
							var index = irandom(array_length(object)-1);
							instance_create_layer(genX, genY, lay, object[index]);
						}
						else
							instance_create_layer(genX, genY, lay, object);
					}
				}
				else if(is_array(sprite)) {
					genX = col*spacing + startX;
					genY = row*spacing + startY;
					spriteToDraw = sprite[irandom_range(1,array_length(sprite)-1)];
					var spr = layer_sprite_create(lay, genX, genY, spriteToDraw);
					if(randomizeAngle)
						layer_sprite_angle(spr, choose(0, 90, 180, 270));
					if(object != -1) {
						if(is_array(object)) {
							var index = irandom(array_length(object)-1);
							instance_create_layer(genX, genY, lay, object[index]);
						}
						else
							instance_create_layer(genX, genY, lay, object);
					}
				}
			}
			else {
				if(!terrainMap.map[col][row]) {
					genX = col*spacing + startX;
					genY = row*spacing + startY;
					var spr = layer_sprite_create(lay, genX, genY, spriteToDraw);
					if(randomizeAngle)
						layer_sprite_angle(spr, choose(0, 90, 180, 270));
					if(object != -1) {
						if(is_array(object)) {
							var index = irandom(array_length(object)-1);
							instance_create_layer(genX, genY, lay, object[index]);
						}
						else
							instance_create_layer(genX, genY, lay, object);
					}
				}
				else if(is_array(sprite)) {
					genX = col*spacing + startX;
					genY = row*spacing + startY;
					spriteToDraw = sprite[irandom_range(1,array_length(sprite)-1)];
					var spr = layer_sprite_create(lay, genX, genY, spriteToDraw);
					if(randomizeAngle)
						layer_sprite_angle(spr, choose(0, 90, 180, 270));
					if(object != -1) {
						if(is_array(object)) {
							var index = irandom(array_length(object)-1);
							instance_create_layer(genX, genY, lay, object[index]);
						}
						else
							instance_create_layer(genX, genY, lay, object);
					}
				}
			}
		}
	}
	if(isBaseTile) {
		generatedX = genX;
		generatedY = genY;
	}
}

function generate(startX, startY, biomeEnum = biomes.FIELD) {
	switch(biomeEnum) {
		case biomes.FIELD: {
			randomize();
			grassMap = new cellular_automata_map(CHUNK_W, CHUNK_H, 1, 0, 0);
			grassMap.iterate(1);
			waterMap = new cellular_automata_map(CHUNK_W, CHUNK_H, 0.7, 5, 3);
			waterMap.iterate(5);
			yellowFilter = new cellular_automata_map(CHUNK_W, CHUNK_H, 0.7, 5, 5)
			yellowFilter.iterate(5);
			spawnTiles(grassMap, [spr_grass, spr_grass2, spr_grass3, spr_grass4], 1, startX, startY, , false, true);
			spawnTiles(yellowFilter, [spr_yellow, spr_brown], 2, startX, startY, , true, false);
			spawnTiles(waterMap, spr_water, 3, startX, startY, , true, false);
		}
	}
}

allChunks = 0;

generatedX = 0;
generatedY = 0;

drawDebugX = 0;
drawDebugY = 0;

placeSprites = function() {
	var lay = layer_get_id("Ground")
	for(var xx=0; xx<ds_grid_width(terrainMap); xx++)
		for(var yy=0; yy<ds_grid_height(terrainMap); yy++) {
			var sprToDraw;
			var ind = numRound(ds_grid_get(terrainMap, xx, yy))
			switch(ind) {
				case 0: {
					sprToDraw = spr_water;
				} break;
				case 1: {
					sprToDraw = spr_water;
				} break;
				case 2: {
					sprToDraw = spr_grass;
				} break;
				case 3: {
					sprToDraw = spr_grass3;
				} break;
				case 4: {
					sprToDraw = spr_grass4;
				} break;
				case 5: {
					sprToDraw = spr_grass5;
				} break;
				case 6: {
					sprToDraw = spr_dirt;
				} break;
				case 7: {
					sprToDraw = spr_dirt;
				} break;
				case 8: {
					sprToDraw = spr_stone;
				} break;
				case 9: {
					sprToDraw = spr_water;
				} break;
				case 10: {
					sprToDraw = spr_water;
				} break;
				default: {
					show_debug_message(string(ind) + " defaulting unknown index")
					sprToDraw = spr_grass;
				} break;
			}
			layer_sprite_create(lay, xx*TILEW, yy*TILEH, sprToDraw);
		}
}

placeChunk = function(mapStartX, mapStartY) {
	var lay = layer_get_id("Ground");
	var startX = mapStartX * CHUNK_W;
	var startY = mapStartY * CHUNK_H;
	for(var xx=startX; xx<startX+CHUNK_W; xx++)
		for(var yy=startY; yy<startY+CHUNK_H; yy++) {
			var sprToDraw;
			var ind = numRound(ds_grid_get(terrainMap, xx, yy))
			switch(ind) {
				case 0: {
					sprToDraw = spr_water;
				} break;
				case 1: {
					sprToDraw = spr_water;
				} break;
				case 2: {
					sprToDraw = spr_grass;
				} break;
				case 3: {
					sprToDraw = spr_grass3;
				} break;
				case 4: {
					sprToDraw = spr_grass4;
				} break;
				case 5: {
					sprToDraw = spr_grass5;
				} break;
				case 6: {
					sprToDraw = spr_dirt;
				} break;
				case 7: {
					sprToDraw = spr_dirt;
				} break;
				case 8: {
					sprToDraw = spr_stone;
				} break;
				case 9: {
					sprToDraw = spr_water;
				} break;
				case 10: {
					sprToDraw = spr_water;
				} break;
				default: {
					show_debug_message(string(ind) + " defaulting unknown index")
					sprToDraw = spr_grass;
				} break;
			}
			layer_sprite_create(lay, xx*TILEW, yy*TILEH, sprToDraw);
		}
}