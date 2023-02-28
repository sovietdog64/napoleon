dungeonMap = ds_grid_create(
	room_width div (MAX_DUNGEON_ROOM_SIZE+TILEW*5),
	room_height div (MAX_DUNGEON_ROOM_SIZE+TILEW*5)
);

x=0;
y=0;

maxRooms = irandom_range(5, 15);

roomCount = 1;

var roomWidth = irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE - TILEW*5);
var roomHeight = irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE - TILEW*5);

dungeonMap[# 0,0] = 1;

dungeonMap[# 0,0] = instance_create_layer(
	TILEW*5, TILEW*5, "Instances", obj_dungeonRoom,
	{
		rmWidth : roomWidth,
		rmHeight : roomHeight,
		mapX : 0,
		mapY : 0,
		creatorID : id,
	}
)