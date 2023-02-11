if(room = rm_init)
	return;
terrainMap = ds_grid_create(power(2, 8)+1, power(2, 8)+1)
diamondSquare(terrainMap, 10, 1, 6969);

var xCount = room_width div PX_CHUNK_W;
var yCount = room_height div PX_CHUNK_H;

allChunks = ds_grid_create(xCount, yCount);