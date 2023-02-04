targX = mouse_x;
targY = mouse_y;
var lineLen = distance_to_point(targX, targY);
lineLen = clamp(lineLen, 0, 300);
var dir = point_direction(x, y, targX, targY);
for(var i=0; i<10; i++) {
	if(!instance_exists(allObjs[i])) {
		allObjs[i] = instance_create_layer(x, y, "Instances", obj_wiggleChild);
	}
	var len = (lineLen div 10)*i;
	var xx = x+lengthdir_x(len, dir);
	var yy = y+lengthdir_y(len, dir);
	allObjs[i].point = new Point(round(xx), round(yy));
}
image_angle = dir;