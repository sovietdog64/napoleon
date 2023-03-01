dungeonMap = ds_grid_create(
	room_width div DUNG_CELL_SIZE,
	room_height div DUNG_CELL_SIZE
);

//Choosing where dungeon map should start
mapPos = new Vec2Zero();
mainBranchDir = new Vec2Zero();

if(choose(1, 0)) {
	mapPos.x = irandom(ds_grid_width(dungeonMap)-3);
	mainBranchDir.y = 1;
}
else {
	mapPos.y = irandom(ds_grid_height(dungeonMap)-3);
	mainBranchDir.x = 1;
}

var newRoomPos = mapPos.copy();

//Making main branch of rooms
for(var i=0; i<branchLen; i++) {
	
	var dirX = mainBranchDir.y;
	var dirY = mainBranchDir.x * choose(1, -1);
	//Stop if the new branch is going to be out of bounds.
	if(!withinBoundsGrid(dungeonMap, newRoomPos.x, newRoomPos.y))
		return;
	
	var roomWidth = irandom_range(MIN_DUNGEON_ROOM_TILES, MAX_DUNGEON_ROOM_TILES);
	var roomHeight = irandom_range(MIN_DUNGEON_ROOM_TILES, MAX_DUNGEON_ROOM_TILES);
	
	dungeonMap[# newRoomPos.x, newRoomPos.y] = instance_create_layer(
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
		}
	)
	newRoomPos.addVec(mainBranchDir);
}