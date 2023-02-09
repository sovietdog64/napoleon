if(room == rm_init)
	return;
layerId = layer_get_id("Ground");

randomize();
grassMap = new cellular_automata_map(CHUNK_W, CHUNK_H, 0.7, 5, 5);
grassMap.iterate(1);
spawnTiles(grassMap, [spr_grass, spr_grass2, spr_grass3], 1, 0, 0, false, true);

//Updating chunk grid
var w = PX_CHUNK_W-TILE_W/2
var h = PX_CHUNK_H-TILE_H/2;
var countw = room_width div w;
var counth = room_width div h;

chunkGrid = ds_grid_create(countw, counth);

//Updating chunk grid
for(var col=0; col<ds_grid_width(chunkGrid); col++) {
	for(var row=0; row<ds_grid_height(chunkGrid); row++) {
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
					})
	}
}

//spawnTiles(waterMap, spr_water, 2, 0, 0)