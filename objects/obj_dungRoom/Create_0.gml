if(variable_instance_exists(id, "noCreateEvent") && noCreateEvent)
	return;
var cellX = mapPos.x*DUNG_CELL_SIZE;
var cellY = mapPos.y*DUNG_CELL_SIZE;

bridgedTo = [];

buildedBridgeTo = [];

//Get the room's cell midpoint for centering
cellMid = new Line(
	cellX, cellY,
	cellX+DUNG_CELL_SIZE, cellY+DUNG_CELL_SIZE
)
cellMid = cellMid.getMidpoint();

x = cellMid.x-rmWidth/2;
y = cellMid.y-rmHeight/2;

alarm_set(0, 2);
	
//90% chance of branching to another room
if(chance(90)) {
	var xx = mapPos.x;
	var yy = mapPos.y;
	
	for(var i=1; i<=4; i++) {
		switch(i) {
			case 1:
				xx--;
			break;
			
			case 2:
				xx++;
			break;
			
			case 3:
				yy--;
			break;
			
			case 4:
				yy--;
			break;
			
		}
		var inst = creatorID.dungeonMap[# xx,yy];
		if(instance_exists(inst))
			if(!array_contains(inst.bridgedTo, id)) {
				array_push(bridgedTo, inst);
				array_push(inst.bridgedTo, id);
				break;
			}
	}
}

if(maxNewRooms <= 0)
	return;

//Stop making new rooms if going out of room.
if(!withinBoundsGrid(
	creatorID.dungeonMap,
	mapPos.x+branchDir.x, mapPos.y+branchDir.y
)) {
	return;
}

var otherMapPos = mapPos.copy();
otherMapPos.addVec(branchDir);

//If rooms will overlap, stop.
if(instance_exists(creatorID.dungeonMap[# otherMapPos.x, otherMapPos.y]))
	return;


obj_dungeonGen.roomCount++;
if(obj_dungeonGen.roomCount >= obj_dungeonGen.maxRooms)
	return;

//Creating the rooms
repeat(maxNewRooms) {
	//Keep going forward in the branch until a free cell is found. Will stay in bounds
	while(instance_exists(creatorID.dungeonMap[# otherMapPos.x, otherMapPos.y]) &&
		  withinBoundsGrid(creatorID.dungeonMap, otherMapPos.x, otherMapPos.y)) {
		otherMapPos.addVec(branchDir);
	}
	
	if(withinBoundsGrid(creatorID.dungeonMap, otherMapPos.x, otherMapPos.y)) {
		//Create new room 
		var roomWidth = irandom_range(MIN_DUNGEON_ROOM_TILES, MAX_DUNGEON_ROOM_TILES);
		var roomHeight = irandom_range(MIN_DUNGEON_ROOM_TILES, MAX_DUNGEON_ROOM_TILES);
		var inst = instance_create_layer(
			otherMapPos.x*DUNG_CELL_SIZE, otherMapPos.y*DUNG_CELL_SIZE,
			"Instances",
			obj_dungRoom,
			{
				rmWidth : roomWidth*TILEW,
				rmHeight : roomHeight*TILEW,
				mapPos : otherMapPos.copy(),
				branchDir : branchDir.copy(),
				creatorID : creatorID,
				maxNewRooms : 0,
			}
		)
		creatorID.dungeonMap[# otherMapPos.x, otherMapPos.y] = inst;
		//Bridge to the new room created
		try {
			array_push(bridgedTo, inst);
			array_push(inst.bridgedTo, id);
		} catch(err) {}
		
		otherMapPos.addVec(branchDir);
	}
	else //stop if out of bounds.
		return;
}