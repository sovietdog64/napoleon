var maxIterations = 300;
repeat(choose(1, 3)) {
	var iterations = 0;
	var xx = mapX;
	var yy = mapY;
	if(creatorID.roomCount >= creatorID.maxRooms)
		return;
	var roomPlacement;
	

	//COnstantly check for new rooms to make.
	//After 300 failed iterations, the dungeon will stop generating
	do {
		xx = mapX;
		yy = mapY;
	
		roomPlacement = choose("left","right","up","down");
		switch(roomPlacement) {
	
			case "left":
				xx--;
			break;
	
			case "right":
				xx++;
			break;
		
			case "up":
				yy--;
			break;
	
			case "down":
				yy++;
			break;
	
		}
		iterations++;
		if(iterations >= maxIterations)
			return;
	}
	until(
		withinBoundsGrid(creatorID.dungeonMap, xx, yy) &&
		creatorID.dungeonMap[# xx,yy] != 1
	);

	creatorID.roomCount++;

	var roomWidth = irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE - TILEW*5);
	var roomHeight = irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE - TILEW*5);
	
	//Set to nonzero value before making room
	creatorID.dungeonMap[# xx,yy] = 1;

	var inst  = instance_create_layer(
		xx*MAX_DUNGEON_ROOM_SIZE+TILEW*5, yy*MAX_DUNGEON_ROOM_SIZE+TILEW*5,
		"Instances",
		obj_dungeonRoom,
		{
			rmWidth : roomWidth,
			rmHeight : roomHeight,
			mapX : xx,
			mapY : yy,
			creatorID : creatorID
		}
	)

	//Set it after, because 
	creatorID.dungeonMap[# xx,yy] = inst;
}
	