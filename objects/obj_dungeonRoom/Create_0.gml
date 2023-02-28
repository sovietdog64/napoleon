var maxIterations = 1000;

var cellx = mapX*(MAX_DUNGEON_ROOM_SIZE+TILEW*5)
var celly = mapY*(MAX_DUNGEON_ROOM_SIZE+TILEW*5)

//Midpoint of cell
midpoint = new Line(	
	cellx,
	celly,
	cellx+(MAX_DUNGEON_ROOM_SIZE+TILEW*5),
	celly+(MAX_DUNGEON_ROOM_SIZE+TILEW*5)
).getMidpoint();

prevX = x;
prevY = y;

//Center the room in the cell.
x = midpoint.x-rmWidth/2;
y = midpoint.y-rmHeight/2;

//Array of rooms that this room is briding to.
bridgedTo = [];


//Spawning rooms
repeat(irandom_range(1, 3)) {
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
	
	array_push(bridgedTo, inst);
	array_push(inst.bridgedTo, id);
	
	//Set it after, because 
	creatorID.dungeonMap[# xx,yy] = inst;
	
}

	//Bridging to other rooms by chance
	//These rooms are not in the path
	if(irandom_range(1, 100) <= 70) {
		var targRoomDirection = choose("left", "right", "up", "down");
		var xx = mapX;
		var yy = mapY;
		var targRm = bridgedTo[0];
		var directionsChecked = [];
		
		//Check around to find another room  to bridge to.
		//Will terminate the loop if it can't bridge to another room.
		//Will not bridge to a room that it is already bridged to.
		while(!withinBoundsGrid(creatorID.dungeonMap, xx, yy) ||
			  array_contains(targRm.bridgedTo, id)) 
		{
			//Add to the directions checked if it failed.
			if(!array_contains(directionsChecked, targRoomDirection))
				array_push(directionsChecked, targRoomDirection);
			
			//If couldn't find any direction to bridge to
			if(array_length(directionsChecked) >= 4)
				return;
			
			xx = mapX;
			yy = mapY;
			targRoomDirection = choose("left", "right", "up", "down");
			
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
			
			try{
				targRm = creatorID.dungeonMap[# xx,yy];
			}
			catch(err) {}
			
			
		}
	}
	