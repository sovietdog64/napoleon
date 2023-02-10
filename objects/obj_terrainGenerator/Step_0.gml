//auto-gen
return;
for(var col=0; col<ds_grid_width(chunkGrid); col++) {
	for(var row=0; row<ds_grid_height(chunkGrid); row++) {
		var r = ds_grid_get(chunkGrid, col, row);
		if(r.loaded)
			continue;
		var unloadedChunkVisible = rectangle_in_rectangle(r.x1,r.y1, r.x2, r.y2, CAMX,CAMY, CAMX2,CAMY2);
		if(unloadedChunkVisible) {
			generate(r.x1, r.y1, r.biome);
			r.loaded = true;
		}
	}
}

var reachingEndOfRoom = rectangle_in_rectangle(CAMX,CAMY, CAMX2+10,CAMY2+10, 0,0, room_width, room_height);
if(reachingEndOfRoom != 1) {
	room_width += PX_CHUNK_W;
	room_height += PX_CHUNK_H;
	var width = ds_grid_width(chunkGrid);
	var height = ds_grid_height(chunkGrid);
	ds_grid_resize(chunkGrid, width+1, height+1);
	
	//Updating chunk grid
	var w = PX_CHUNK_W-TILE_W/2
	var h = PX_CHUNK_H-TILE_H/2;
	var countw = room_width div w;
	var counth = room_width div h;

	chunkGrid = ds_grid_create(countw, counth);

	//Updating chunk grid
	for(var col=0; col<ds_grid_width(chunkGrid); col++) {
		for(var row=0; row<ds_grid_height(chunkGrid); row++) {
			if(is_struct(ds_grid_get(chunkGrid, col, row)))
				continue;
			var xx1 = col*w;
			var yy1 = row*h;
			var xx2 = xx1 + w;
			var yy2 = yy1 + h;
			var isLoaded = false;
			if(col == 0 && row = 0)
				isLoaded = true;
			ds_grid_set(chunkGrid,
						col,row,
						{
							x1 : xx1,
							y1 : yy1,
							x2 : xx2,
							y2 : yy2,
							loaded : isLoaded,
							biome : biomes.FIELD,
						})
		}
	}
}
