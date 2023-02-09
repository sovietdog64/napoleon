function spawnTiles(terrainMap, sprite, spriteOrder, startX, startY, object = -1, invertPlacement = false, isBaseTile = false) {
	var genX = startX;
	var genY = startY;
	var spriteToDraw = sprite;
	if(is_array(sprite))
		spriteToDraw = sprite[0];
	var lay = layer_create(layer_get_depth(layerId) - spriteOrder, sprite_get_name(spriteToDraw) + " layer");
	var spacing = TILE_W;
	for(var col = 0; col < terrainMap.width; col++) {
		for(var row = 0; row < terrainMap.height; row++) {
			if(is_array(sprite))
				spriteToDraw = sprite[0];
			if(!invertPlacement) {
				if(terrainMap.map[col][row]) {
					genX = col*spacing + startX;
					genY = row*spacing + startY;
					var spr = layer_sprite_create(lay, genX, genY, spriteToDraw);
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

function generate(startX, startY) {
	spawnTiles(grassMap, [spr_grass, spr_grass2, spr_grass3, spr_grass4], 1, startX, startY, , false, true);
	spawnTiles(waterMap, spr_water, 2, startX, startY, , true, false);
}

layerId = layer_get_id("Ground");

generatedX = 0;
generatedY = 0;


//Updating chunk grid
chunkGrid = ds_grid_create(1, 1);
//Updating chunk grid
for(var col=0; col<ds_grid_width(chunkGrid); col++) {
	for(var row=0; row<ds_grid_height(chunkGrid); row++) {
		var xx1 = col*PX_CHUNK_W;
		var yy1 = row*PX_CHUNK_H;
		var xx2 = xx1 + PX_CHUNK_W;
		var yy2 = yy1 + PX_CHUNK_H;
		ds_grid_set(chunkGrid,
					col,row,
					{
						x1 : xx1,
						y1 : yy1,
						x2 : xx2,
						y2 : yy2,
						loaded : false,
					})
	}
}
//terrainMap.iterate(10);
//spawnTiles(0, 0);