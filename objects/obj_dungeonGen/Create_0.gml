dungeonMap = ds_grid_create(
	room_width div MAX_DUNGEON_ROOM_SIZE,
	room_height div MAX_DUNGEON_ROOM_SIZE
);

x=0;
y=0;

maxRooms = 5;

roomCount = 1;

mapStartX = 0;
mapStartY = 0;

var roomWidth = irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE);
var roomHeight = irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE);

dungeonMap[# mapStartX, mapStartY] = instance_create_layer(
	0, 0, "Instances", obj_dungeonRoom,
	{
		rmWidth : roomWidth,
		rmHeight : roomHeight,
		mapX : mapStartX,
		mapY : mapStartY,
		creatorID : id,
	}
)
