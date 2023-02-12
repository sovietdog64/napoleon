numOfBuildings = irandom_range(10, 11);
buildings = [];

roads = [];

largestLen = 0;

randomize();

for(var i=0; i<numOfBuildings; i++) {
	var spr = choose(spr_house, spr_house2, spr_house3, spr_house4);
	var inst = instance_create_layer(x, y, "Structures", obj_house)
	inst.sprite_index = spr;
	array_push(buildings, inst);
	if(inst.sprite_width > largestLen)
		largestLen += inst.sprite_width
	if(inst.sprite_height > largestLen)
		largestLen += inst.sprite_height
}

for(var i=0; i<361; i += 90) {
	var xx = x+lengthdir_x(largestLen, i)
	var yy = y+lengthdir_y(largestLen*2, i)
	var struct = {
		line : new Line(x, y, xx, yy),
		buildings : [],
		lengthFilled : 0,
	}
	array_push(roads, struct);
	//Extending line has 30% chance of spawning
	if(irandom_range(1, 100) <= 30) {
		var dir = choose(0, 90, 180, 270);
		var xx2 = xx+lengthdir_x(largestLen, dir);
		var yy2 = yy+lengthdir_y(largestLen, dir);
		var struct = {
			line : new Line(xx, yy, xx2, yy2),
			buildings : [],
			lengthFilled : 0,
		}
		array_push(roads, struct);
	}
}

for(var i=0; i<numOfBuildings; i++) {
	var road = roads[irandom(array_length(roads)-1)];
	var l = road.line;
	var dist = distanceBetweenPoints(l.x1, l.y1, l.x2, l.y2);
	while(road.lengthFilled > dist) {
		road = roads[irandom(array_length(roads)-1)];
		l = road.line;
		dist = distanceBetweenPoints(l.x1, l.y1, l.x2, l.y2);
	}
	var buildingLength = buildings[i].sprite_width;
	if(buildings[i].sprite_height > buildingLength) 
		buildingLength = buildings[i].sprite_height;
	var len = irandom_range(buildingLength+road.lengthFilled, dist);
	var dir = point_direction(l.x1, l.y1, l.x2, l.y2);
	var xx = l.x1 + lengthdir_x(len, dir);
	var yy = l.y1 + lengthdir_y(len, dir);
	buildings[i].x = xx;
	buildings[i].y = yy;
	buildings[i].image_angle = dir-90;
	
	road.lengthFilled += buildingLength;
}