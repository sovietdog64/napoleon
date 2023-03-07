if(room == rm_init || room == rm_dungeon)
	return;

deactivatedInstances = [];

try {
	
	var xCount = ds_grid_width(global.chunksGrid);
	var yCount = ds_grid_height(global.chunksGrid);
	for(var xx=0; xx<xCount; xx++) {
		for(var yy=0; yy<yCount; yy++) {
			global.chunksGrid[# xx,yy].loaded = false;
		}
	}
	
} catch(err) {};

if(global.loadedOverworld)
	return;

global.loadedOverworld = true;

var xCount = room_width div PX_CHUNK_W;
var yCount = room_height div  PX_CHUNK_H;

global.chunksGrid = ds_grid_create(xCount, yCount);

if(!layer_exists(layer_get_id("Ground")))
	layer_create(100, "Ground");
var size = power(2, 8)+1;
global.terrainGrid = ds_grid_create(size, size)
lazyFloodFill(global.terrainGrid, 0, 0, 0.99999);
diamondSquare2(global.terrainGrid, 11, 0, global.randomSeed);
ds_grid_clear(global.chunksGrid, 0);

playerSpawnSetup = true;

for(var xx=0; xx<ds_grid_width(global.chunksGrid); xx++)
	for(var yy=0; yy<ds_grid_height(global.chunksGrid); yy++) {
		prepareChunk(xx,yy);
	}

show_debug_message("prepared chunks for: " + room_get_name(room));

//If player still didn't spawn, then force-spawn the player in a random chunk
while(playerSpawnSetup == true) {
	var xx = irandom(ds_grid_width(global.chunksGrid));
	var yy = irandom(ds_grid_height(global.chunksGrid));
	if(!is_struct(global.chunksGrid[# xx, yy]))
		continue;
	if(global.chunksGrid[# xx, yy].structureType == structureTypes.GROUND) {
		playerSpawnSetup = false;
		var playerSpawnX = irandom_range(xx*PX_CHUNK_W, xx*PX_CHUNK_W + PX_CHUNK_W);
		var playerSpawnY = irandom_range(yy*PX_CHUNK_W, yy*PX_CHUNK_W + PX_CHUNK_W);
		instance_create_layer(playerSpawnX, playerSpawnY, "Instances", obj_player);
		giveItemToPlayer(new WoodHatchet())
	}
}