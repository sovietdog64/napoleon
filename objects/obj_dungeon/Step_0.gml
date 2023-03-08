var inst = collision_rectangle(
	x-TILEW, y-TILEW,x+TILEW, y+TILEW,
	obj_player,
	0,1
);

if(inst != noone && !prevPlayerEntered) {
	prevPlayerEntered = true;
	//If a saved room isnt assigned to this dungeon, then make a new one and assign it
	if(!variable_instance_exists(id, "roomAddress")) {
		
		//Generate new address and assign it
		roomAddress = string(irandom_range(1, 2147483648)) + "_dungeon";
		while(variable_struct_exists(global.levelData.dungeonRooms, roomAddress))
			roomAddress = string(irandom_range(1, 2147483648)) + "_dungeon";
		
		
		global.dungeonCreationCode = function () {
			instance_create_depth(
				x, y,
				100,
				obj_dungeonGen,
				{
					groundSpr : spr_dungFloor,
					wallSpr : spr_dungWall,
					itemsSold : itemsSold,
					itemPrices : itemPrices,
					chestItems : chestItems,
					enemy1Obj : enemy1Obj,
					enemy2Obj : enemy2Obj,
					enemy3Obj : enemy3Obj,
				})
		}
			
		
		//Prevent the game from loading a non-existing dungeon
		global.canLoadGame = false;
	}
	else { //if room was already saved & assigned to this dungeon, then clear the room creation code.
		global.dungeonCreationCode = function() {};
	}
	
	//Update the dungeon room address for saving/loading later on.
	global.dungeonRoomAddress = roomAddress;
	
	
	room_goto(rm_dungeon);
}
else if(inst == noone && prevPlayerEntered)
	prevPlayerEntered = false;

