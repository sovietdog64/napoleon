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
		if(camInBounds != 0) {
			ds_grid_set(allChunks, xx, yy,
			{
				biome : biomes.FIELD,
				structures : array_create(0),
			});
			placeChunk(xx,yy);
		}
	}
}