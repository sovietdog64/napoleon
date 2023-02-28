draw_set_color(c_red);
draw_rectangle(
	x,y,
	x+rmWidth,y+rmHeight,
	1
)

var cellx = mapX*(MAX_DUNGEON_ROOM_SIZE+TILEW*5)
var celly = mapY*(MAX_DUNGEON_ROOM_SIZE+TILEW*5)
draw_set_color(c_green);
draw_rectangle(
	cellx,
	celly,
	cellx+(MAX_DUNGEON_ROOM_SIZE+TILEW*5),
	celly+(MAX_DUNGEON_ROOM_SIZE+TILEW*5),
	1
)

draw_set_color(c_gray)
for(var i=0; i<array_length(bridgedTo); i++) {
	var rm = bridgedTo[i]
	if(!instance_exists(rm))
		continue;
	var rmMid = rm.midpoint;
	draw_line(
		midpoint.x, midpoint.y,
		rmMid.x, rmMid.y
	)
}
	
