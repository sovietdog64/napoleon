if(variable_instance_exists(id, "noCreateEvent"))
	return;
var cellX = mapPos.x*DUNG_CELL_SIZE;
var cellY = mapPos.y*DUNG_CELL_SIZE;

bridgedTo = [];
buildedBridgeTo = [];

//Get the room's cell midpoint for centering
cellMid = new Line(
	cellX, cellY,
	cellX+DUNG_CELL_SIZE, cellY+DUNG_CELL_SIZE)
cellMid = cellMid.getMidpoint();

x = cellMid.x-rmWidth/2;
y = cellMid.y-rmHeight/2;

alarm_set(0, 2);



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

obj_dungeonGen.roomCount++;
if(obj_dungeonGen.roomCount >= obj_dungeonGen.maxRooms)
	return;

//Creating new room
var roomWidth = irandom_range(MIN_DUNGEON_ROOM_TILES, MAX_DUNGEON_ROOM_TILES);
var roomHeight = irandom_range(MIN_DUNGEON_ROOM_TILES, MAX_DUNGEON_ROOM_TILES);

var newBranchDir = branchDir.copy();
if(choose(0, 1)) {
	newBranchDir.flip();
}

var inst = instance_create_layer(
	otherMapPos.x*DUNG_CELL_SIZE, otherMapPos.y*DUNG_CELL_SIZE,
	"Instances",
	obj_dungRoom,
	{
		rmWidth : roomWidth*TILEW,
		rmHeight : roomHeight*TILEW,
		mapPos : otherMapPos.copy(),
		branchDir : newBranchDir,
		creatorID : creatorID,
		maxNewRooms : maxNewRooms,
	}
)
creatorID.dungeonMap[# otherMapPos.x, otherMapPos.y] = inst;

try {
	array_push(bridgedTo, inst);
	array_push(inst.bridgedTo, id);
} catch(err) {}