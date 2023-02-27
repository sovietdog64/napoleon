var inst = collision_rectangle(
	x-TILEW, y-TILEW,x+TILEW, y+TILEW,
	obj_player,
	0,1
);

if(inst != noone) {
	room_goto(rm_dungeon);
}