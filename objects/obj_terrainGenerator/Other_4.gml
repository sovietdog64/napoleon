if(room == rm_init || room == rm_dungeon || room == rm_mainMenu || room == rm_cutscene)
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

if(global.loadedOverworld) {
	return;
}

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

for(var xx=0; xx<ds_grid_width(global.chunksGrid); xx++)
	for(var yy=0; yy<ds_grid_height(global.chunksGrid); yy++) {
		prepareChunk(xx,yy);
	}

#region spawning structures

var numOfDungeons = irandom_range(6, 10);
repeat(numOfDungeons) {
	var spawnedStructure = false;
	
	while(!spawnedStructure) {
		var chunkX = irandom(ds_grid_width(global.chunksGrid)-1);
		var chunkY = irandom(ds_grid_height(global.chunksGrid)-1);
		
		var structure = spawnStructure(chunkX, chunkY, obj_dungeon);
		//If successfuly spawned, then push structure to array in chunk struct.
		if(structure != undefined) {
			spawnedStructure = true;
			array_push(global.chunksGrid[# chunkX, chunkY].structures, structure);
		}
	}
}

#endregion spawning structures


show_debug_message("prepared chunks for: " + room_get_name(room));

//spawn the player in a random position.
instance_create_layer(random_range(100, room_width), random_range(100, room_height), "Instances", obj_player);
global.spawnX = obj_player.x;
global.spawnY = obj_player.y;
giveItemToPlayer(new WoodHatchet())