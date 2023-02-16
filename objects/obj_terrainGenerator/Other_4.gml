if(room = rm_init)
	return;
var xCount = room_width div PX_CHUNK_W;
var yCount = room_height div PX_CHUNK_H;

allChunks = ds_grid_create(xCount, yCount);

if(!layer_exists(layer_get_id("Ground")))
	layer_create(100, "Ground");
var size = power(2, 8)+1;
terrainMap = ds_grid_create(size, size)
lazyFloodFill(terrainMap, 0, 0, 0.99999);
diamondSquare2(terrainMap, 10, 0);
ds_grid_clear(allChunks, 0);
if(debug_mode)
	//Place all chunks 
	for(var xx=0; xx<ds_grid_width(allChunks); xx++) 
		for(var yy=0; yy<ds_grid_height(allChunks); yy++) {
			placeChunk(xx, yy);
		}