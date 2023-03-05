var inst = collision_rectangle(
	x-TILEW, y-TILEW,x+TILEW, y+TILEW,
	obj_player,
	0,1
);

if(inst != noone) {
	global.dungeonCreationCode = function () {
		instance_create_depth(
			x, y,
			100,
			obj_dungeonGen,
			{
				groundSpr : spr_dungFloor,
				wallSpr : spr_dungWall,
			})
	}
	room_goto(rm_dungeon);
}

