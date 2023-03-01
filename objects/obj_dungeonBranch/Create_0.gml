var cellX = mapPos.x*DUNG_CELL_SIZE;
var cellY = mapPos.y*DUNG_CELL_SIZE;

bridgedTo = [];

//Get the room's cell midpoint for centering
cellMid = new Line(
	cellX, cellY,
	cellX+DUNG_CELL_SIZE, cellY+DUNG_CELL_SIZE)
cellMid = cellMid.getMidpoint();

if(maxNewRooms <= 0)
	return;


//If the new room is going to be out of bounds, go the opposite direction in creating rooms.
if(!withinBoundsGrid(
	creatorID.dungeonMap,
	mapPos.x+branchDir.x, mapPos.y+branchDir.y
)) {
	branchDir.negate();
}

var otherMapPos = mapPos.copy();
otherMapPos.addVec(branchDir);

if(!withinBoundsGrid(creatorID.dungeonMap, otherMapPos.x, otherMapPos.y) ||
	instance_exists(creatorID.dungeonMap[# otherMapPos.x, otherMapPos.y]))
{
	return;
}


var inst = instance_create_layer(
	otherMapPos.x*DUNG_CELL_SIZE, otherMapPos.y*DUNG_CELL_SIZE,
	"Instances",
	obj_dungRoom,
	{
		rmWidth : irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE-TILEW*5),
		rmHeight : irandom_range(MIN_DUNGEON_ROOM_SIZE, MAX_DUNGEON_ROOM_SIZE-TILEW*5),
		mapPos : otherMapPos.copy(),
		branchDir : branchDir.copy(),
		creatorID : creatorID,
		maxNewRooms : maxNewRooms,
	}
)
creatorID.dungeonMap[# otherMapPos.x, otherMapPos.y] = inst;

array_push(bridgedTo, inst);
array_push(inst.bridgedTo, id);
