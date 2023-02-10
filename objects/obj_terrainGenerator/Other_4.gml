if(room = rm_init)
	return;

//Load full world map with random seed
terrainMap = diamondSquare(power(2, 12), , 8);

var xCount = room_width div PX_CHUNK_W;
var yCount = room_height div PX_CHUNK_H;
allChunks = ds_grid_create(xCount, yCount);
