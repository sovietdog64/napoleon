x=0;
y=0;
//Random start position
if(choose(0, 1)) {
	x = choose(
		0,
		room_width/2,
		room_width
	)
}
else {
	y = choose(
		0,
		room_height/2,
		room_height
	)
}

dungeonMap = ds_grid_create(4, 4);

mapStartX = x div (room_width/MAX_DUNGEON_ROOM_SIZE);
mapStartY = y div (room_height/MAX_DUNGEON_ROOM_SIZE);

var xx = mapStartX, yy = mapStartY;

var roomPlacement = choose("left", "right", "up", "down");
var roomWidth = irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE)+TILEW;
var roomHeight = irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE)+TILEW;
var x1 = xx*(room_width/roomWidth);
var y1 = yy*(room_height/roomHeight);

dungeonMap[# xx, yy] = instance_create_layer(
	x1, y1, "Instances", obj_dungeonRoom,
	{
		rmWidth : roomWidth,
		rmHeight : roomHeight,
		mapX : xx,
		mapY : yy,
		creatorID : id,
	}
)
return;
//Keep trying until a room that fits is made.
while(rectangle_in_rectangle(
	x1, y1,
	x1+roomWidth, y1+roomHeight,
	0,0, room_width, room_height) != 1)
{
	roomPlacement = choose("left", "right", "up", "down");
	
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
	
	roomWidth = irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE)+TILEW;
	roomHeight = irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE)+TILEW;
	x1 = xx*(room_width/roomWidth);
	y1 = yy*(room_height/roomHeight);
}

