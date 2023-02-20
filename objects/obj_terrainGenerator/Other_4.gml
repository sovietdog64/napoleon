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
diamondSquare2(terrainMap, 11, 0);
ds_grid_clear(allChunks, 0);

playerSpawnSetup = true;

for(var xx=0; xx<ds_grid_width(allChunks);xx++)
	for(var yy=0; yy<ds_grid_height(allChunks); yy++) {
		loadChunk(xx,yy);
	}

//If player still didn't spawn, then force-spawn the player in a random chunk
while(playerSpawnSetup == true) {
	var xx = irandom(ds_grid_width(allChunks));
	var yy = irandom(ds_grid_height(allChunks));
	if(allChunks[# xx, yy].structureType == structureTypes.GROUND) {
		playerSpawnSetup = false;
		var playerSpawnX = irandom_range(xx*PX_CHUNK_W, xx*PX_CHUNK_W + PX_CHUNK_W);
		var playerSpawnY = irandom_range(yy*PX_CHUNK_W, yy*PX_CHUNK_W + PX_CHUNK_W);
		instance_create_layer(playerSpawnX, playerSpawnY, "Instances", obj_player);
		giveItemToPlayer(new WoodHatchet())
	}
}