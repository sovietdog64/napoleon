var xCount = ds_grid_width(allChunks);
var yCount = ds_grid_height(allChunks);
//Loop through all chunks and see if it is unloaded and visible at the same time.
//if it is, then load the chunk
for(var xx=0; xx<xCount; xx++) {
	for(var yy=0; yy<yCount; yy++) {
		//If chunk loaded, continue.
		if(allChunks[# xx, yy].loaded) {
			continue;
		}
		
		var chunkX = xx*PX_CHUNK_W;
		var chunkY = yy*PX_CHUNK_H;
		var camInBounds = rectangle_in_rectangle(CAMX, CAMY, CAMX2, CAMY2,
												chunkX, chunkY, chunkX+PX_CHUNK_W, chunkY+PX_CHUNK_H);
		if(camInBounds) {
			placeChunk(xx,yy);
		}
		
		if(pointDistToRect(
			chunkX, chunkY, chunkX+PX_CHUNK_W, chunkY+PX_CHUNK_H,
			CAMX, CAMY
		) > global.renderDist) 
		{
			unloadChunk(xx, yy)
		}
	}
}
	
//Load strucutres when part of them are seen
var inst = collision_rectangle(CAMX, CAMY, CAMX2, CAMY2, obj_structurePar, 0, 1);
if(inst != noone && !inst.loaded) {
	inst.loaded = true;
	var creator = inst;
	//Find the first ancestor of the strucutre found
	while(variable_instance_exists(creator, "creatorID")) {
		creator = creator.creatorID;
	}
	//and set it to be loaded.
	if(variable_instance_exists(creator, "loaded")) {
		creator.loaded = true;
		show_debug_message("loaded ancestor")
	}
}