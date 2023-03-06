var inst = collision_rectangle(
	x-TILEW, y-TILEW,x+TILEW, y+TILEW,
	obj_player,
	0,1
);


if(inst != noone) {
	//If no room assigned to this instance
	if(!variable_instance_exists(id, "rmAddr")) {
		//then assign one.
		rmAddr = string(irandom_range(0, 2147483648)) + "_dungeon";
		while(variable_struct_exists(global.levelData.dungeons, rmAddr))
			rmAddr = string(irandom_range(0, 2147483648)) + "_dungeon";
		
		global.levelData.dungeons[$ rmAddr] = {};
		global.dungeonRoomAddr = rmAddr;
		
		//And create a new dungeon in the room
		global.dungeonCreationCode = function () {
			instance_create_depth(
				x, y,
				100,
				obj_dungeonGen,
				{
					groundSpr : spr_dungFloor,
					wallSpr : spr_dungWall,
					itemsSold : [new WoodSword(), new WoodHatchet(), new Wood(10), new Handle(3)],
					itemPrices : [20, 30, 10, 4],
					chestItems : [new WoodHatchet(234)]
				})
		}
	}
	else { //If there is a room assigned
		//Then update which dungeon to load
		global.dungeonRoomAddr = rmAddr;
	}
	
	room_goto(rm_dungeon);
}

