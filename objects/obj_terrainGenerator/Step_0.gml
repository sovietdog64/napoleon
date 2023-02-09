if(instance_exists(obj_player)) {
	for(var col=0; col<ds_grid_width(chunkGrid); col++) {
		for(var row=0; row<ds_grid_height(chunkGrid); row++) {
			var r = ds_grid_get(chunkGrid, col, row);
			if(r.loaded)
				continue;
			var unloadedChunkVisible = rectangle_in_rectangle(r.x1,r.y1, r.x2, r.y2, CAMX,CAMY, CAMX+RESOLUTION_W,CAMY+RESOLUTION_H);
			if(unloadedChunkVisible) {
				spawnTiles(grassMap, [spr_grass, spr_grass2, spr_grass3], 1, r.x1, r.y1, false, true);
				r.loaded = true;
			}
		}
	}
}