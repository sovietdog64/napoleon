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
				itemsSold : [new WoodSword(), new WoodHatchet(), new Wood(10), new Handle(3)],
				itemPrices : [20, 30, 10, 4],
				chestItems : [new WoodHatchet(234)]
			})
	}
	room_goto(rm_dungeon);
}

