
var xCount = ds_grid_width(allChunks);
var yCount = ds_grid_height(allChunks);
//Loop through all chunks and see if it is unloaded and visible at the same time.
//if it is, then load the chunk
for(var xx=0; xx<xCount; xx++) {
	for(var yy=0; yy<yCount; yy++) {
		//If chunk loaded, continue.
		if(is_struct(ds_grid_get(allChunks, xx, yy))) {
			continue;
		}
		
		var chunkX = xx*PX_CHUNK_W;
		var chunkY = yy*PX_CHUNK_H;
		var camInBounds = rectangle_in_rectangle(CAMX, CAMY, CAMX2, CAMY2,
												chunkX, chunkY, chunkX+PX_CHUNK_W, chunkY+PX_CHUNK_H);
		
		//If unloaded chunk visible, load it
		var lay = layer_get_id("Ground");
		if(camInBounds != 0) {
			//Loop through chunk's map info
			for(var col=xx; col<xx+CHUNK_W; col++)
				for(var row=yy; row<yy+CHUNK_H; row++) {
					var sprToDraw = spr_grass;
					var tileX = chunkX+(TILEW*(col-xx));
					var tileY = chunkY+(TILEH*(row-yy));
					//picking which sprite to draw based on the number of the tile
					switch(ds_grid_get(terrainMap, col, row)) {
						case 1: {
							sprToDraw = spr_grass
						} break;
						case 2: {
							sprToDraw = spr_grass2
						} break;
						case 3: {
							sprToDraw = spr_grass3
						} break;
						case 4: {
							sprToDraw = spr_grass4
						} break;
						case 5: {
							sprToDraw = spr_grass5
						} break;
						case 6: {
							sprToDraw = spr_water
						} break;
						case 7: {
							sprToDraw = spr_ground
						} break;
					}
					layer_sprite_create(lay, tileX, tileY, sprToDraw);
				}
			
			//Set chunk info. will be able to add structures later.
			ds_grid_set(allChunks, xx, yy, 
						{
							biome : biomes.FIELD,
							structures : [],
						});
		}
	}
}