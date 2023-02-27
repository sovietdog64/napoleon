var xx = mapX;
var yy = mapY;
if(creatorID.roomCount >= creatorID.maxRooms)
	return;
	
do {
	
	var roomPlacement = choose("left","right","up","down");
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
	
}
until(
	!withinBoundsGrid(creatorID.dungeonMap, xx, yy) ||
	instance_exists(creatorID.dungeonMap[# xx,yy])
);

var roomWidth = irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE);
var roomHeight = irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE);

creatorID.dungeonMap[# xx,yy] = instance_create_layer(
	xx*MAX_DUNGEON_ROOM_SIZE, yy*MAX_DUNGEON_ROOM_SIZE,
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

creatorID.roomCount++;