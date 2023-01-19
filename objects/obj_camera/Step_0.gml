if(!instance_exists(obj_player)) return;
var xx = targX - camera_get_view_width(view_camera[0])/2;
var yy = targY - camera_get_view_height(view_camera[0])/2;
//Prevent camera from viewing things outside of the map
if(xx + camera_get_view_width(view_camera[0]) > room_width) xx = x;
if(yy + camera_get_view_height(view_camera[0]) > room_height) yy = y;
move_towards_point(xx, yy, distance_to_point(xx, yy)/5);
x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height);
camera_set_view_pos(view_camera[0], x, y);