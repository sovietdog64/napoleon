spawnSquares = function(terrainMap, sprite, spriteOrder, startX, startY) {
	var lay = layer_create(layer_get_depth(layerId) - spriteOrder, sprite_get_name(sprite) + " layer");
	var spacing = sprite_get_width(sprite);
	for(var col = 0; col < terrainMap.width; col++) {
		for(var row = 0; row < terrainMap.height; row++) {
			if(terrainMap.map[col][row]) 
				layer_sprite_create(lay, col*spacing + startX, row*spacing + startY, sprite);
		}
	}
}

layerId = layer_get_id("Ground");

generatedWidth = 0;
generatedHeight = 0

//terrainMap.iterate(10);
//spawnSquares(0, 0);
