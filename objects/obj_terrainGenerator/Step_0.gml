var xCount = ds_grid_width(allChunks);
var yCount = ds_grid_height(allChunks);
//Loop through all chunks and see if it is unloaded and visible at the same time.
//if it is, then load the chunk
for(var xx=0; xx<xCount; xx++) {
	for(var yy=0; yy<yCount; yy++) {
		var chunkX = xx*PX_CHUNK_W;
		var chunkY = yy*PX_CHUNK_H;
		
		var dist = global.renderDist*PX_CHUNK_H;
		
		//Use collisiong recangle instead because gammaker is cringe
		instance_deactivate_region(CAMX-dist, CAMY-dist, RESOLUTION_W+dist, RESOLUTION_H+dist, false, 1);
		instance_activate_region(CAMX-dist, CAMY-dist, RESOLUTION_W+dist, RESOLUTION_H+dist, true);
		
		//If chunk loaded, continue.
		if(allChunks[# xx, yy].loaded) {
			continue;
		}
		
		var camInBounds = rectangle_in_rectangle(CAMX, CAMY, CAMX2, CAMY2,
												chunkX, chunkY, chunkX+PX_CHUNK_W, chunkY+PX_CHUNK_H);
		
		if(camInBounds) {
			placeChunk(xx,yy);
		}
	}
}