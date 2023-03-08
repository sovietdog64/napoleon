if(variable_instance_exists(id, "noCreateEvent") && noCreateEvent) {
	noCreateEvent = false;
	return;
}
dungeonGrid = ds_grid_create(
	room_width div DUNG_CELL_SIZE,
	room_height div DUNG_CELL_SIZE
);

alarm_set(0, 1)

roomCount = 0;

branches = [];

//Choosing where dungeon map should start
mapPos = new Vec2Zero();
mainBranchDir = new Vec2Zero();

if(choose(1, 0)) {
	mapPos.x = irandom(ds_grid_width(dungeonGrid)-3);
	mainBranchDir.y = 1;
}
else {
	mapPos.y = irandom(ds_grid_height(dungeonGrid)-3);
	mainBranchDir.x = 1;
}

var newRoomPos = mapPos.copy();

//Making main branch of rooms
for(var i=0; i<branchLen; i++) {
	
	var dirX = mainBranchDir.y;
	var dirY = mainBranchDir.x * choose(1, -1);
	//Stop if the new branch is going to be out of bounds.
	if(!withinBoundsGrid(dungeonGrid, newRoomPos.x, newRoomPos.y))
		return;
	
	var roomWidth = irandom_range(MIN_DUNGEON_ROOM_TILES, MAX_DUNGEON_ROOM_TILES);
	var roomHeight = irandom_range(MIN_DUNGEON_ROOM_TILES, MAX_DUNGEON_ROOM_TILES);
	
	var inst = instance_create_layer(
		newRoomPos.x*DUNG_CELL_SIZE, newRoomPos.y*DUNG_CELL_SIZE,
		"Instances",
		obj_dungeonBranch,
		{
			rmWidth : roomWidth*TILEW,
			rmHeight : roomHeight*TILEW,
			branchDir : new Vector2(dirX, dirY),
			mapPos : newRoomPos.copy(),
			creatorID : id,
			maxNewRooms : irandom_range(1, 3),
			wallSpr : wallSpr,
			groundSpr : groundSpr,
		}
	)
	
	if(i == 0) {
		with(inst) {
			instance_destroy(obj_player);
				instance_create_layer(cellMid.x,cellMid.y, "Instances", obj_player); 
			global.spawnX = cellMid.x;
			global.spawnY = cellMid.y;
			isSpawnRoom = true;
		}
	}
	dungeonGrid[# newRoomPos.x, newRoomPos.y] = inst;
	branches[i] = inst;
	
	newRoomPos.addVec(mainBranchDir);
}
for(var i=0; i<array_length(branches); i++) {
	if(i != 0) {
		var branch = branches[i];
		array_push(branch.bridgedTo, branches[i-1]);
		array_push(branches[i-1].bridgedTo, branch);
	}
}
	
if(instance_exists(obj_dungeonDoor))
	obj_dungeonDoor.solid = false;