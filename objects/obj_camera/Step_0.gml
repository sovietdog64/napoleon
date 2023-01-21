if(!instance_exists(obj_player)) return;
var xx = targX - camWidth()/2;
var yy = targY - camHeight()/2;
//Prevent camera from viewing things outside of the map
var inBounds = rectangle_in_rectangle(xx+10,yy+10, xx+camWidth()-10,yy+camHeight()-10, 0,0, room_width, room_height);
if(!inBounds) {
	xx = x;
	yy = y;
}

yy = clamp(yy+camHeight(), camHeight(), room_height-1)-camHeight();
xx = clamp(xx+camWidth(), camWidth(), room_width-1)-camWidth();

//Move towards target
move_towards_point(xx, yy, distance_to_point(xx, yy)/5);
//Extra check to prevent camera going out of map
x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height);
camera_set_view_pos(view_camera[0], x, y);