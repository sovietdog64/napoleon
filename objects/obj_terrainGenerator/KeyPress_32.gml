layer_destroy(layer_get_id("Ground"))
var lay = layer_create(100, "Ground")
var size = power(2, 8)+1;
terrainMap = ds_grid_create(size, size)
lazyFloodFill(terrainMap, 0, 0, 0.99999)
diamondSquare2(terrainMap, 10, 0)
ds_grid_clear(allChunks, 0)

//placeSprites();
return;

for(var xx=0; xx<size; xx++)
	for(var yy=0; yy<size; yy++) {
		var tileX = xx*TILEW;
		var tileY = yy*TILEH;
		switch(ds_grid_get(terrainMap, xx, yy)) {
			case 1: {
				layer_sprite_create(lay, tileX, tileY, spr_grass);
			} break;
			case 0: {
				layer_sprite_create(lay, tileX, tileY, spr_water);
			} break;
		}
	}