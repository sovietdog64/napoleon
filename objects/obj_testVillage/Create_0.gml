roads = [];
//Might use this variable to prevent other strucutres from spawning in the village's radius
radius = 0;

//Roads
for(var i=0; i<360; i += 90) { //Roads spawn in directions of all quadrantial directions
	var xScale = irandom_range(10, 30);
	var inst = instance_create_layer(x, y, "Structures", obj_villPath,
															{
																image_angle : i,
																image_xscale : xScale,
																loaded : loaded,
															})
	//Update radius when a longer path is created
	if(inst.sprite_width > radius)
		radius = inst.sprite_width
	array_push(roads, inst);
	
	//30% chance of spawning a path that branches off this one.
	if(irandom(100) <= 30) {
		var dir = choose(0, 90, 180, 270);
		//Prevent new path from pointing into the path it is branching off from
		if(dir == i-180)
			dir += 90;
		var xx = x+lengthdir_x(inst.sprite_width, i);
		var yy = y+lengthdir_y(inst.sprite_width, i);
		var newPath = instance_create_layer(xx, yy, "Structures", obj_villPath,
														{
															image_angle : dir,
															image_xscale : irandom_range(10, 30),
															loaded : loaded
														})
		//Update radius if the distance to the end of the new path is longer
		var pathEndX = xx+lengthdir_x(newPath.sprite_width, dir);
		var pathEndY = yy+lengthdir_y(newPath.sprite_width, dir);
		var dist = distance_to_point(pathEndX, pathEndY);
		if(dist > radius)
			radius = dist;
		array_push(roads, newPath);
	}
}
prevLoaded = loaded;

event_inherited()