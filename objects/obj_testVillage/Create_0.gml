roads = [];

//Roads
for(var i=0; i<360; i += 90) {
	var xx = x + lengthdir_x(300, i);
	var yy = y + lengthdir_y(300, i);
	instance_create_layer(xx, yy, "Structures", obj_villPath,
															{
																image_angle : i,
																image_xscale : irandom_range(10, 30),
															})
}